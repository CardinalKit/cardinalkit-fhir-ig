ValueSet: OMHUnitValue
Id: omh-unit-value
Title: "OMH to FHIR Unit Value Set"
Description: "Implicit OMH units (not explicitly enumerated in the schemas) needed for OMH to FHIR mapping"
* ^version = "0.0.0"
* ^status = #draft
* ^date = "2018-11-28T15:55:00.13Z"
* ^publisher = "Open mHealth"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.openmhealth.org/"
* ^immutable = false
* ^copyright = "Open mHealth copyright 2015, a project of the Tides Center. All Rights Reserved."
* $unitsofmeasure#{steps} "steps"
* $unitsofmeasure#mm[Hg] "mmHg"
* $unitsofmeasure#mg/dL "mg/dL"
* $unitsofmeasure#mmol/L "mmol/L"
* $unitsofmeasure#kg/m2 "kg/m^2"
* $unitsofmeasure#kCal "kcal"
* $unitsofmeasure#/beats/min "beats/min"
* $unitsofmeasure#/breaths/min "breaths/min"
* $unitsofmeasure#% "%"