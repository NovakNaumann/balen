extends SceneTree

const MANIFEST_PATH := "res://source_data/voyage/source_manifest.json"
const EXPECTED_SOURCE_FILENAME := "balen_35_low_hp_d20_known_patch.json"
const EXPECTED_SOURCE_HASH := "E7C75DFA082DE61FD0AFD1CBE242179764BE5533EEF27B10E29E55E17344606B"
const REQUIRED_DOCS := [
	"../docs/Balen_Codex_Playable_Test_Phase_Plan.md",
	"../docs/Balen_Codex_Game_Testbed_Plan.md",
	"../docs/Balen_World_Canon_Bible.md",
	"../docs/decisions.md",
	"../docs/assumptions.md",
	"../docs/known_issues.md",
	"../docs/playtest_checklist.md",
]
const REQUIRED_REFERENCE_IMAGES := [
	"../docs/reference/aethelgard_concept_crossroads_plaza.png",
	"../docs/reference/painterly_reference_rookmire_curios.png",
	"../docs/reference/painterly_reference_aethelgard_jeweler.png",
	"../docs/reference/painterly_reference_worcen_knight.png",
	"../docs/reference/painterly_reference_magi_knight_researcher.png",
]
const FORBIDDEN_TERMS := [
	"Dragonborn",
	"Dragonborne",
	"Worcester",
	"Worchester"
]


func _initialize() -> void:
	var errors: Array[String] = []
	var warnings: Array[String] = []

	_validate_manifest(errors, warnings)
	_validate_docs(errors, warnings)
	_validate_reference_images(errors)

	for warning in warnings:
		print("BALEN_CONTENT_WARNING: %s" % warning)

	if errors.is_empty():
		print("BALEN_CONTENT_VALIDATION_OK")
		quit(0)
		return

	for error in errors:
		push_error(error)
	print("BALEN_CONTENT_VALIDATION_FAILED %d" % errors.size())
	quit(1)


func _validate_manifest(errors: Array[String], warnings: Array[String]) -> void:
	if not FileAccess.file_exists(MANIFEST_PATH):
		errors.append("Missing source manifest: %s" % MANIFEST_PATH)
		return

	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		errors.append("Unable to read source manifest: %s" % MANIFEST_PATH)
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		errors.append("Source manifest must be a JSON object.")
		return

	if parsed.get("source_filename", "") != EXPECTED_SOURCE_FILENAME:
		errors.append("Source manifest must name the latest copied Voyage JSON snapshot.")

	if parsed.get("source_hash_sha256", "") != EXPECTED_SOURCE_HASH:
		errors.append("Source manifest hash does not match the latest copied Voyage JSON snapshot.")

	if parsed.get("heroes_version", "") != "Voyage.IO Heroes V35":
		errors.append("Source manifest must record Voyage.IO Heroes V35.")

	var authority_documents: Variant = parsed.get("authority_documents", [])
	if typeof(authority_documents) != TYPE_ARRAY or not authority_documents.has("docs/Balen_Codex_Playable_Test_Phase_Plan.md"):
		errors.append("Source manifest must record the playable test phase plan as an authority document.")

	if not bool(parsed.get("source_present", false)):
		warnings.append("Original Voyage JSON is not present yet; importer work remains blocked until it is added read-only.")
	else:
		var source_path := "res://source_data/voyage/%s" % str(parsed.get("source_filename", ""))
		if not FileAccess.file_exists(source_path):
			errors.append("Manifest says source is present, but file is missing: %s" % source_path)
		elif FileAccess.get_file_as_bytes(source_path).size() != int(parsed.get("source_byte_size", -1)):
			errors.append("Copied source JSON byte size does not match source manifest.")


func _validate_docs(errors: Array[String], _warnings: Array[String]) -> void:
	for doc_path in REQUIRED_DOCS:
		var absolute_doc_path := ProjectSettings.globalize_path("res://%s" % doc_path)
		if not FileAccess.file_exists(absolute_doc_path):
			errors.append("Missing authority document: %s" % absolute_doc_path)
			continue

		var file := FileAccess.open(absolute_doc_path, FileAccess.READ)
		if file == null:
			errors.append("Unable to read authority document: %s" % absolute_doc_path)
			continue

		var text := file.get_as_text()
		if doc_path.ends_with("Balen_World_Canon_Bible.md"):
			if not text.contains("Drakken"):
				errors.append("Canon bible must preserve current Drakken terminology.")
			if not text.contains("true dragon"):
				errors.append("Canon bible must preserve true dragon terminology.")
			if not text.contains("false-wyrm"):
				errors.append("Canon bible must preserve false-wyrm terminology.")

		for term in FORBIDDEN_TERMS:
			if text.contains(term) and not doc_path.ends_with("Balen_World_Canon_Bible.md"):
				errors.append("Forbidden legacy term appears outside canon-bible context: %s" % term)


func _validate_reference_images(errors: Array[String]) -> void:
	for image_path in REQUIRED_REFERENCE_IMAGES:
		var absolute_image_path := ProjectSettings.globalize_path("res://%s" % image_path)
		if not FileAccess.file_exists(absolute_image_path):
			errors.append("Missing reference image: %s" % absolute_image_path)
