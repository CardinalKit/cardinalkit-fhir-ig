Extension: OmhModalityExtension
Id: extension-modality
Title: "OMH to FHIR Modality Extension"
Description: "How the measure was obtained - either sensed or self-reported."
* ^version = "0.0.0"
* ^experimental = false
* ^date = "2019-06-06"
* ^context.type = #element
* ^context.expression = "Observation.device"
* . 0..1
* . ^short = "How the measure was obtained - either sensed or self-reported."
* . ^definition = "How the measure was obtained - either sensed or self-reported."
* url only uri
* value[x] only code
* value[x] from $modality-codes (required)
* value[x] ^binding.description = "How the measure was obtained - either sensed or self-reported."