The following tables are used to map data between OMH and FHIR. CardinalKit stores a header and body for each OMH data point. OMH Headers are mapping to FHIR Observation and Provenance resources. OMH Body is mapped to FHIR Observation.

### OMH Header to FHIR Observation Mapping Table

|OMH Header Element|FHIR Attribute|Mapping|
|---|---|---|
|header.id||"urn:uuid:" + header.id|
|header.id|identifier[0].system|fixed to "urn:ietf:rfc:3986"|
|header.creation_date_time|issued|= header.creation_date_time|
|header.schema_id|None||
|header.schema_id.namespace|None||
|header.schema_id.name|category[0].coding[0].code|Map header.schema_id.name to column "Observation.category.code" using  the [OMH DataPoint Element to FHIR Element Mapping Table](/d4c66YHxQxi9Xqv_0qBpJA)|
|header.schema_id.name|category[0].coding[0].system|fixed to "http://hl7.org/fhir/observation-category"|
|header.schema_id.name|code.coding[0].code|Map header.schema_id.name to column "Observation.code.code" using  the [data_point_mapping_table](#)|
|header.schema_id.name|code.coding[0].system|Map header.schema_id.name to column "Observation.code.system" using  the [data_point_mapping_table](#)|
|header.schema_id.name|code.coding[0].display|Map header.schema_id.name to column "Observation.code.display" using  the [data_point_mapping_table](#)|
|header.schema_id.version|None||
|header.acquisition_provenance|None||
|header.acquisition_provenance.source_name|device.display|= header.acquisition_provenance.source_name|
|header.acquisition_provenance.source_data_point_id|identifier[1].value|concatenation of  "urn:uuid:" + header.acquisition_provenance.source_data_point_id|
|header.acquisition_provenance.source_data_point_id|identifier[1].system|fixed to "urn:ietf:rfc:3986"|
|header.acquisition_provenance.source_creation_date_time|None||
|header.acquisition_provenance.modication_date_time|None||
|header.acquisition_provenance.modality|device.extension[0].valueCode|= header.acquisition_provenance.modality|
|header.acquisition_provenance.modality|device.extension[0].url|"http://www.fhir.org/mfhir/StructureDefinition/extension-modality"|
|header.user_id|subject.identifier.value|"urn:uuid:" + header.user_id|
|header.user_id|subject.identifier.system|"urn:ietf:rfc:3986"|
{: .grid}


### OMH Header to FHIR Provenance Mapping Table

The following table provides the detailed mapping for the OMH Header to the OMH to FHIR Provenance Profile.

|OMH Header Element|FHIR Attribute|Mapping Instructions|
|---|---|---|
|header-1.2.json|OMH to FHIR  Provenance Profile||
|None|Provenance.activity.text|fixed to "transform"|
|None|Provenance.target.reference|fixed to "#" since  Provenance  is contained in Observation|
|None|Provenance.recorded|System provided value indicates the instant the omh message was transformed to a FHIR resource.|
|None|Provenance.policy|fixed to "http://www.fhir.org/guides/mfhir/ImplementationGuide/openmhealth.mfhir-0.0.0" Provenance.policy can optionally point to the  omh-fhir ig rules url used for the transformation|
|None|Provenance.agent[0].type.coding[0].system|fixed to "http://terminology.hl7.org/CodeSystem/provenance-participant-type"|
|None|Provenance.agent[0].type.coding[0].code|fixed to "assembler"|
|None|Provenance.agent[0].type.coding[0].display|fixed to "Assembler"|
|None|Provenance.agent[0].type.who.reference|Provenance.agent.who references the Organization or Device performing the transformation. For example, "Device/example-r24-server"|
|None|Provenance.agent[1].type.text|fixed to "omh-schema"|
|None|Provenance.entity[0]|Provenance.entity is optional.  see entity elements below|
|None|Provenance.entity[0].role|fixed to "derivation"|
|header.id|Provenance.entity[0].what.identifier[0].value|concatenation of  "urn:uuid:" + header.id|
|header.id|Provenance.entity[0].what.identifier[0].system|fixed to "urn:ietf:rfc:3986"|
|header.creation_date_time|None||
|header.schema_id|None||
|header.schema_id.namespace|Provenance.agent[1].type.who.identifier.value|concatenation of  header.schema_id.namespace + header.schema_id.name + header.schema_id.version|
|header.schema_id.name|Provenance.agent[1].type.who.identifier.value|concatenation of  header.schema_id.namespace + header.schema_id.name + header.schema_id.version|
|header.schema_id.version|Provenance.agent[1].type.who.identifier.value|concatenation of  header.schema_id.namespace + header.schema_id.name + header.schema_id.version|
|header.schema_id.url|Provenance.agent[1].type.who.reference|1:1 mapping of  header.schema_id.url|
|header.acquisition_provenance|None||
|header.acquisition_provenance.source_name|Provenance.agent[2].type.coding[0].system|fixed to "http://terminology.hl7.org/CodeSystem/provenance-participant-type"|
|header.acquisition_provenance.source_name|Provenance.agent[2].type.coding[0].code|fixed to "AUT"|
|header.acquisition_provenance.source_name|Provenance.agent[2].type.coding[0].display|fixed to Author|
|header.acquisition_provenance.source_name|Provenance.agent[2].who.display|1:1 mapping of  header.acquisition_provenance.source_name|
|header.acquisition_provenance.source_data_point_id|None||
|header.acquisition_provenance.source_creation_date_time|None||
|header.acquisition_provenance.last_modification_date_time|None||
|header.acquisition_provenance.modality|None||
|header.user_id|None||
{: .grid}


### OMH Data Point to FHIR Observation Mapping Table

Each Datapoint is represented by the body properties and this table is a summary of the OMH datapoint schema type as represented by the `header.schema_id.name` element to the corresponding FHIR Observation `category` and 'code' elements and default units for quantitative measures.

|header.schema_id.name|Observation.category.code|Observation.code.system|Observation.code.code|Observation.code.display|observation_value_quantity_unit(s) (list)|descriptive_statistic|descriptive_statistic_denominator|components|
|--|--|--|--|--|--|--|--|--|
|acceleration|physical-activity|http://loinc.org|80493-0|Activity level [Acceleration]|None|False|False|[]|
|ambient_temperature|None|http://loinc.org|60832-3|Room temperature|None|False|False|[]|
|blood_glucose|laboratory|http://loinc.org|2339-0|Glucose Mass/volume in Blood|['mg/dL', 'mmol/L']|True|False|['temporal_relationship_to_sleep', 'temporal_relationship_to_meal']|
|blood_pressure|vital-signs|http://loinc.org|85354-9|Blood pressure panel with all children optional|None|True|False|['diastolic_blood_pressure', 'systolic_blood_pressure']|
|body_fat_percentage|exam|http://loinc.org|41982-0|Percentage of body fat Measured|['%']|True|False|[]|
|body_height|vital-signs|http://loinc.org|8302-2|Body height|['cm', 'in']|False|False|[]|
|body_mass_index|vital-signs|http://loinc.org|39156-5|Body mass index (BMI) Ratio|['kg/m^2']|True|False|[]|
|body_temperature|vital-signs|http://loinc.org|8310-5|Body temperature|['K','F','C']|True|False|['temporal_relationship_to_sleep']|
|body_weight|vital-signs|http://loinc.org|29463-7|Body weight|['kg', 'g', 'lb']|True|False|[]|
|breath_carbon_monoxide|laboratory|http://snomed.info/id|251900003|Expired carbon monoxide concentration (observable entity)|None|False|False|[]|
|calories_burned|physical-activity|http://loinc.org|41981-2|Calories burned|['kcal']|True|True|[]|
|diastolic_blood_pressure|vital-signs|http://loinc.org|8462-4|Diastolic blood pressure|['mmHg']|False|False|[]|
|expiratory_time|exam|http://loinc.org|60739-0|Expiration Time Respiratory system|None|False|False|[]|
|geoposition|physical-activity|http://www.fhir.org/guides/omhtofhir/datapoint-type|geoposition|Geoposition|None|False|False|[]|
|heart_rate|vital-signs|http://loinc.org|8867-4|Heart rate|['beats/min']|True|False|['temporal_relationship_to_physical_activity', 'temporal_relationship_to_sleep']|
|inspiratory_time|exam|http://loinc.org|60740-8|Inspiration Time Respiratory system|None|False|False|[]|
|magnetic_force|physical-activity|http://www.fhir.org/guides/omhtofhir/datapoint-type|magnetic_force|Magnetic Force Panel|None|False|False|[]|
|medication_adherence_percent|Survey|http://snomed.info/id|418633004|Medication compliance (observable entity)|None|False|False|[]|
|minute_volume|exam|http://loinc.org|20139-2|Volume expired 1 minute|None|False|False|[]|
|minutes_moderate_activity|physical-activity|http://snomed.info/id|408581006|Physical activity target moderate exercise (finding)|['min']|False|False|[]|
|orientation|vital-signs|http://www.fhir.org/guides/omhtofhir/datapoint-type|orientation|Gyroscope measurement Panel|None|False|False|[]|
|oxygen_saturation|vital-signs|http://loinc.org|59408-5|Oxygen saturation in Arterial blood by Pulse oximetry|['%']|True|False|['supplemental_oxygen_flow_rate', 'oxygen_therapy_mode_of_administration']|
|pace|physical-activity|http://www.fhir.org/guides/omhtofhir/datapoint-type|pace|Pace|None|False|False|[]|
|physical_activity|physical-activity|http://snomed.info/id|68130003|Physical activity (observable entity)|None|False|False|[]|
|respiratory_rate|vital-signs|http://loinc.org|9279-1|Respiratory Rate|['breaths/min']|True|False|['temporal_relationship_to_physical_activity']|
|rr_interval|exam|http://loinc.org|8637-1|R_R interval by EKG|None|False|False|[]|
|sleep_duration|physical-activity|http://snomed.info/id|248263006|Duration of sleep (observable entity)|['sec', 'min', 'h']|True|True|[]|
|sleep_episode|physical-activity|http://snomed.info/id|258158006|Sleep, function (observable entity)|None|False|False|[]|
|speed|physical-activity|http://ncimeta.nci.nih.gov|C0678536|Speed|None|False|False|[]|
|step_count|physical-activity|http://loinc.org|55423-8|Number of steps in unspecified time Pedometer|['steps']|True|True|[]|
|systolic_blood_pressure|vital-signs|http://loinc.org|8480-6|Systolic blood pressure|['mmHg']|False|False|[]|
|ventilation_cycle_time|exam|http://snomed.info/id|250818005|Ventilation cycle time (observable entity)|None|False|False|[]|
{:.grid}


### OMH Data Point to FHIR Observation Component Mapping Table

Some Datapoints properties are represented by the FHIR `Observation.component` element in FHIR.  This table summarizes these OMH datapoint schema properties and list the corresponding OMH propertied name in the  `Component Name` column and its corresponding FHIR Observation component code and valuetype attributes.  This table is used along with the OMH to FHIR concept mapping table to to populate the the Observation template below.

|Component Name|Component Code System|Component Code Code|Component Code Display|Component Value Type|
|--|--|--|--|--|
|body_posture|http://snomed.info/sct|271605009|Position of body and posture (observable entity)|valueCodeableConcept|
|diastolic_blood_pressure|http://loinc.org|8462-4|Diastolic blood pressure|valueQuantity|
|systolic_blood_pressure|http://loinc.org|8480-6|Systolic blood pressure|valueQuantity|
|temporal_relationship_to_meal|http://www.fhir.org/guides/omhtofhir/omh_fhir_observation_codes|relative-to-meal|OMH to FHIR Temporal Relationship To Meal|valueCodeableConcept|
|temporal_relationship_to_physical_activity|http://www.fhir.org/guides/omhtofhir/omh_fhir_observation_codes|relative-to-activity|OMH to FHIR Temporal Relationship To Physical Activity|valueCodeableConcept|
|temporal_relationship_to_sleep|http://www.fhir.org/guides/omhtofhir/omh_fhir_observation_codes|relative-to-sleep|OMH to FHIR Temporal Relationship To Sleep|valueCodeableConcept|
{: .grid}