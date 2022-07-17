Profile: CKObservationProfile
Parent: Observation
Id: ck-obs
Title: "CardinalKit mHealth Observation Profile"
Description: "Observation Profile used for representing mobile health data in CardinalKit applications"
* ^version = "1.0.0"
* ^experimental = false
* ^date = "2022-01-31"
* . ^mustSupport = false
* identifier MS
* status only code
* status = #unknown (exactly)
* category MS
* code MS
* subject only Reference
* subject MS
* effective[x] MS
* issued MS
* value[x] only Quantity
* value[x] MS
* note
* bodySite MS
* method MS
* device MS
* device.extension contains OmhModalityExtension named modality 0..*
* component MS
* component.code MS
* component.value[x] only CodeableConcept or Quantity
* component.value[x] MS