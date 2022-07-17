The CardinalKit iOS application serializes HealthKit data points into JSON based on [Open mHealth](http://openmhealth.org) (OMH) schemas as described in [this mapping table](https://github.com/CardinalKit/Granola/blob/main/Docs/hkobject_type_coverage.md). All data points are made up of a `header` which contains metadata and a `body` containing a measurement. The first table below shows how the `header` can be mapped to FHIR `Observation` resources, and the following tables describe mapping for the `body`.

### OMH Data Point Header to FHIR Observation Mapping Table

The following is an example header from a heart rate measurement:

```
{
    "id": "082A9300-F351-4660-9F05-754F675FA3DF",
    "creation_date_time": "2022-01-25T01:57:01.000-08:00",
    "schema_id": {
        "namespace": "omh",
        "name": "heart-rate",
        "version": "2.0"
    },
    "acquisition_provenance": {
        "source_name": "HealthKit",
        "source_creation_date_time": "2022-01-25T01:57:01.000-08:00",
        "modality": "sensed"
    },
    "user_id": "GXdCOUJHuIUPUYiViVlNqZp9rjb1"
}

```

Elements found in the OMH header are mapped to FHIR `Observation` resource elements as described in the following table.

| OMH Header Element                          | FHIR Attribute                | Mapping                                                                |
| ------------------------------------------- | ----------------------------- | ---------------------------------------------------------------------------------- |
| id                                          | identifier[0].value           | One-to-one                                                                 |
| creation_date_time                          | issued                        | One-to-one                                                                 |
| schema_id.name                              | N/A                           | Follow the mapping table below to map the schema to all related attributes in FHIR |
| acquisition_provenance.source_name          | device.display                | One-to-one                                                                 |
| acquisition_provenance.source_data_point_id | identifier[1].value           | One-to-one                                                                 |
| acquisition_provenance.modality             | device.extension[0].valueCode | One-to-one                                                                 |
| user_id                                     | subject.identifier.value      | One-to-one                                                                 |
{: .grid}

Note: While Open mHealth suggests that the OMH `header` could also be mapped to the FHIR `Provenance` resource, CardinalKit has not taken this approach.

### OMH Data Point Body to FHIR Observation Mapping Table

The following example shows the body of a data point.

```
{
    "heart_rate": {
        "value": 67,
        "unit": "beats/min"
    },
    "effective_time_frame": {
        "date_time": "2022-01-25T01:57:01.000-08:00"
    },
    "temporal_relationship_to_sleep": "on waking"
}
```

This table shows how data points from specific OMH schemas supported by the CardinalKit framework, such as the example above, can be mapped to FHIR `Observation` resources. The schema name is found in the `header.schema_id.name` property of the data point's header. Some data points have multiple components, similar to the example given above, which contains a `temporal_relation_to_sleep` component in addition to the heart rate value, and their mapping is further described in the next table.

| OMH Schema Name              | Observation Category | Observation Coding System                           | Observation Coding Code | Observation Coding Display                                | Observation Value Quantity Units | Observation Components                                                           |
| ---------------------------- | -------------------- | --------------------------------------------------- | ----------------------- | --------------------------------------------------------- | -------------------------------- | -------------------------------------------------------------------------------- |
| acceleration                 | physical-activity    | http://loinc.org                                    | 80493-0                 | Activity level [Acceleration]                             |                                  |
| ambient_temperature          |                      | http://loinc.org                                    | 60832-3                 | Room temperature                                          |                                  |                                                                                  |
| blood_glucose                | laboratory           | http://loinc.org                                    | 2339-0                  | Glucose Mass/volume in Blood                              | ['mg/dL', 'mmol/L']              | ['temporal_relationship_to_sleep', 'temporal_relationship_to_meal']              |
| blood_pressure               | vital-signs          | http://loinc.org                                    | 85354-9                 | Blood pressure panel with all children optional           |                                  | ['diastolic_blood_pressure', 'systolic_blood_pressure']                          |
| body_fat_percentage          | exam                 | http://loinc.org                                    | 41982-0                 | Percentage of body fat Measured                           | ['%']                            |                                                                                  |
| body_height                  | vital-signs          | http://loinc.org                                    | 8302-2                  | Body height                                               | ['cm', 'in']                     |                                                                                  |
| body_mass_index              | vital-signs          | http://loinc.org                                    | 39156-5                 | Body mass index (BMI) Ratio                               | ['kg/m^2']                       |                                                                                  |
| body_temperature             | vital-signs          | http://loinc.org                                    | 8310-5                  | Body temperature                                          | ['K','F','C']                    | ['temporal_relationship_to_sleep']                                               |
| body_weight                  | vital-signs          | http://loinc.org                                    | 29463-7                 | Body weight                                               | ['kg', 'g', 'lb']                |                                                                                  |
| breath_carbon_monoxide       | laboratory           | http://snomed.info/id                               | 251900003               | Expired carbon monoxide concentration (observable entity) |                                  |                                                                                  |
| calories_burned              | physical-activity    | http://loinc.org                                    | 41981-2                 | Calories burned                                           | ['kcal']                         |                                                                                  |
| diastolic_blood_pressure     | vital-signs          | http://loinc.org                                    | 8462-4                  | Diastolic blood pressure                                  | ['mmHg']                         |                                                                                  |
| expiratory_time              | exam                 | http://loinc.org                                    | 60739-0                 | Expiration Time Respiratory system                        |                                  |                                                                                  |
| heart_rate                   | vital-signs          | http://loinc.org                                    | 8867-4                  | Heart rate                                                | ['beats/min']                    | ['temporal_relationship_to_physical_activity', 'temporal_relationship_to_sleep'] |
| inspiratory_time             | exam                 | http://loinc.org                                    | 60740-8                 | Inspiration Time Respiratory system                       |                                  |                                                                                  |
| medication_adherence_percent | Survey               | http://snomed.info/id                               | 418633004               | Medication compliance (observable entity)                 |                                  |                                                                                  |
| minute_volume                | exam                 | http://loinc.org                                    | 20139-2                 | Volume expired 1 minute                                   |                                  |                                                                                  |
| minutes_moderate_activity    | physical-activity    | http://snomed.info/id                               | 408581006               | Physical activity target moderate exercise (finding)      | ['min']                          |                                                                                  |
| orientation                  | vital-signs          | http://www.fhir.org/guides/omhtofhir/datapoint-type | orientation             | Gyroscope measurement Panel                               |                                  |                                                                                  |
| oxygen_saturation            | vital-signs          | http://loinc.org                                    | 59408-5                 | Oxygen saturation in Arterial blood by Pulse oximetry     | ['%']                            | ['supplemental_oxygen_flow_rate', 'oxygen_therapy_mode_of_administration']       |
| pace                         | physical-activity    | http://www.fhir.org/guides/omhtofhir/datapoint-type | pace                    | Pace                                                      |                                  |                                                                                  |
| physical_activity            | physical-activity    | http://snomed.info/id                               | 68130003                | Physical activity (observable entity)                     |                                  |                                                                                  |
| respiratory_rate             | vital-signs          | http://loinc.org                                    | 9279-1                  | Respiratory Rate                                          | ['breaths/min']                  | ['temporal_relationship_to_physical_activity']                                   |
| rr_interval                  | exam                 | http://loinc.org                                    | 8637-1                  | R_R interval by EKG                                       |                                  |                                                                                  |
| sleep_duration               | physical-activity    | http://snomed.info/id                               | 248263006               | Duration of sleep (observable entity)                     | ['sec', 'min', 'h']              |                                                                                  |
| sleep_episode                | physical-activity    | http://snomed.info/id                               | 258158006               | Sleep, function (observable entity)                       |                                  |                                                                                  |
| speed                        | physical-activity    | http://ncimeta.nci.nih.gov                          | C0678536                | Speed                                                     |                                  |                                                                                  |
| step_count                   | physical-activity    | http://loinc.org                                    | 55423-8                 | Number of steps in unspecified time Pedometer             | ['steps']                        |                                                                                  |
| systolic_blood_pressure      | vital-signs          | http://loinc.org                                    | 8480-6                  | Systolic blood pressure                                   | ['mmHg']                         |                                                                                  |
| ventilation_cycle_time       | exam                 | http://snomed.info/id                               | 250818005               | Ventilation cycle time (observable entity)                |                                  |                                                                                  |
{:.grid}

### OMH Data Point to FHIR Observation Component Mapping Table

As seen in the example above, some OMH data points contain multiple components which can be represented by the FHIR Observation's `component` element.

| Component Name                             | Component Coding System                                | Component Coding Code | Component Coding Display                         | Component Value Type |
| ------------------------------------------ | ------------------------------------------------------ | --------------------- | ------------------------------------------------ | -------------------- |
| body_posture                               | http://snomed.info/sct                                 | 271605009             | Position of body and posture (observable entity) | valueCodeableConcept |
| diastolic_blood_pressure                   | http://loinc.org                                       | 8462-4                | Diastolic blood pressure                         | valueQuantity        |
| systolic_blood_pressure                    | http://loinc.org                                       | 8480-6                | Systolic blood pressure                          | valueQuantity        |
| temporal_relationship_to_meal              | http://cardinalkit.org/fhir/omh_fhir_observation_codes | relative-to-meal      | Temporal Relationship To Meal                    | valueCodeableConcept |
| temporal_relationship_to_physical_activity | http://cardinalkit.org/fhir/omh_fhir_observation_codes | relative-to-activity  | Temporal Relationship To Physical Activity       | valueCodeableConcept |
| temporal_relationship_to_sleep             | http://cardinalkit.org/fhir/omh_fhir_observation_codes | relative-to-sleep     | Temporal Relationship To Sleep                   | valueCodeableConcept |
{: .grid}

### HealthKit Data Point to FHIR Observation Mapping Table

Many HealthKit (HK) data types do not have corresponding OMH schemas, and are serialized by the CardinalKit iOS application using the generic [hk-quantity-type](https://www.openmhealth.org/schemas/granola_hk-quantity-type/) schema. The following table shows how these data points can be mapped to FHIR Observations. Codings which have a particular time interval defined should be mapped values from HK summary queries (`HKStatisticsQuery`) over that time interval. Mapping HK category and characteristic types is not currently supported.

| HealthKit Type                                    | Observation Category Code | Observation Coding System | Observation Coding Code | Observation Coding Display                               |
| ------------------------------------------------- | ------------------------- | ------------------------- | ----------------------- | -------------------------------------------------------- |
| HKQuantityTypeIdentifierBodyMassIndex             | vital-signs               | http://loinc.org          | 39156-5                 | Body mass index (BMI) (Ratio)                            |
| HKQuantityTypeIdentifierBodyFatPercentage         | vital-signs               | http://loinc.org          | 41982-0                 | Percentage of body fat Measured                          |
| HKQuantityTypeIdentifierHeight                    | vital-signs               | http://loinc.org          | 8302-2                  | Body Height                                              |
| HKQuantityTypeIdentifierBodyMass                  | vital-signs               | http://loinc.org          | 29463-7                 | Body Weight                                              |
| HKQuantityTypeIdentifierLeanBodyMass              | vital-signs               | http://loinc.org          | 88334-8                 | Lean body weight Calculated                              |
| HKQuantityTypeIdentifierWaistCircumference        | vital-signs               | http://loinc.org          | 8280-0                  | Waist circumference at umbilicus by tape measure         |
| HKQuantityTypeIdentifierStepCount                 | activity                  | http://loinc.org          | 55423-8                 | Number of steps in unspecified time Pedometer            |
| HKQuantityTypeIdentifierDistanceWalkingRunning    | activity                  | http://loinc.org          | 5430-3                  | Distance walked in unspecified time Pedometer            |
| HKQuantityTypeIdentifierActiveEnergyBurned        | activity                  | http://loinc.org          | 41981-2                 | Calories burned                                          |
| HKQuantityTypeIdentifierFlightsClimbed            | activity                  | http://loinc.org          | 93833-2                 | Flights climbed 24 hour                                  |
| HKQuantityTypeIdentifierVO2Max                    | vital-signs               | http://loinc.org          | 60842-2                 | Oxygen consumption (vO2)                                 |
| HKQuantityTypeIdentifierHeartRate                 | vital-signs               | http://loinc.org          | 8867-4                  | Heart rate                                               |
| HKQuantityTypeIdentifierBodyTemperature           | vital-signs               | http://loinc.org          | 8310-5                  | Body temperature                                         |
| HKQuantityTypeIdentifierBloodPressureSystolic     | vital-signs               | http://loinc.org          | 8480-6                  | Systolic blood pressure                                  |
| HKQuantityTypeIdentifierBloodPressureDiastolic    | vital-signs               | http://loinc.org          | 8462-4                  | Diastolic blood pressure                                 |
| HKQuantityTypeIdentifierRespiratoryRate           | vital-signs               | http://loinc.org          | 9279-1                  | Respiratory rate                                         |
| HKQuantityTypeIdentifierRestingHeartRate          | vital-signs               | http://loinc.org          | 40443-4                 | Heart rate --resting                                     |
| HKQuantityTypeIdentifierWalkingHeartRateAverage   | vital-signs               | http://loinc.org          | 89273-7                 | Heart rate --W exercise                                  |
| HKQuantityTypeIdentifierHeartRateVariabilitySDNN  | vital-signs               | http://loinc.org          | 80404-7                 | R-R interval.standard deviation (Heart rate variability) |
| HKQuantityTypeIdentifierOxygenSaturation          | vital-signs               | http://loinc.org          | 20564-1                 | Oxygen saturation in Blood                               |
| HKQuantityTypeIdentifierPeripheralPerfusionIndex  | vital-signs               | http://loinc.org          | 61006-3                 | Perfusion index tissue by Pulse Oximetry                 |
| HKQuantityTypeIdentifierBloodGlucose              | laboratory                | http://loinc.org          | 2339-0                  | Glucose (Mass/Volume) in Blood                           |
| HKQuantityTypeIdentifierNumberOfTimesFallen       | social-history            | http://loinc.org          | 52552-7                 | Falls in the past year                                   |
| HKQuantityTypeIdentifierBloodAlcoholContent       | laboratory                | http://loinc.org          | 5640-8                  | Ethanol (Mass/volume) in Blood                           |
| HKQuantityTypeIdentifierForcedVitalCapacity       | exam                      | http://loinc.org          | 19870-5                 | Forced vital capacity (Volume)                           |
| HKQuantityTypeIdentifierForcedExpiratoryVolume1   | exam                      | http://loinc.org          | 20150-9                 | FEV1                                                     |
| HKQuantityTypeIdentifierPeakExpiratoryFlowRate    | exam                      | http://loinc.org          | 33452-4                 | Maximum expiratory gas flow                              |
| HKQuantityTypeIdentifierDietaryFatTotal           | social-history            | http://loinc.org          | 9067-0                  | Fat intake Measured                                      |
| HKQuantityTypeIdentifierDietaryFatPolyunsaturated | social-history            | http://loinc.org          | 9067-0                  | Polyunsaturated fat intake 24 hour Measured              |
| HKQuantityTypeIdentifierDietaryFatMonounsaturated | social-history            | http://loinc.org          | 81899-7                 | Monounsaturated fat intake 24 hour Measured              |
| HKQuantityTypeIdentifierDietaryCholesterol        | social-history            | http://loinc.org          | 81022-6                 | Cholesterol intake 24 hour Measured                      |
| HKQuantityTypeIdentifierDietarySodium             | social-history            | http://loinc.org          | 81012-7                 | Sodium intake 24 hour Measured                           |
| HKQuantityTypeIdentifierDietaryCarbohydrates      | social-history            | http://loinc.org          | 81953-2                 | Carbohydrate intake 24 hour Measured                     |
| HKQuantityTypeIdentifierDietaryFiber              | social-history            | http://loinc.org          | 81057-2                 | Fiber intake 24 hour Measured                            |
| HKQuantityTypeIdentifierDietaryEnergyConsumed     | social-history            | http://loinc.org          | 80494-8                 | Calorie intake 24 hour Measured                          |
| HKQuantityTypeIdentifierDietaryProtein            | social-history            | http://loinc.org          | 82156-1                 | Protein intake 24 hour Measured                          |
| HKQuantityTypeIdentifierDietaryVitaminA           | social-history            | http://loinc.org          | 81073-9                 | Vitamin A intake 24 hour Measured                        |
| HKQuantityTypeIdentifierDietaryVitaminB6          | social-history            | http://loinc.org          | 81065-5                 | Vitamin B6 intake 24 hour Measured                       |
| HKQuantityTypeIdentifierDietaryVitaminB12         | social-history            | http://loinc.org          | 81063-0                 | Vitamin B12 intake 24 hour Measured                      |
| HKQuantityTypeIdentifierDietaryVitaminC           | social-history            | http://loinc.org          | 81075-4                 | Vitamin C intake 24 hour Measured                        |
| HKQuantityTypeIdentifierDietaryVitaminD           | social-history            | http://loinc.org          | 81930-0                 | Vitamin D intake 24 hour Measured                        |
| HKQuantityTypeIdentifierDietaryVitaminE           | social-history            | http://loinc.org          | 81077-0                 | Vitamin E intake 24 hour Measured                        |
| HKQuantityTypeIdentifierDietaryVitaminK           | social-history            | http://loinc.org          | 81075-4                 | Vitamin K intake 24 hour Measured                        |
| HKQuantityTypeIdentifierDietaryCalcium            | social-history            | http://loinc.org          | 80975-6                 | Calcium intake 24 hour Measured                          |
| HKQuantityTypeIdentifierDietaryIron               | social-history            | http://loinc.org          | 81075-4                 | Iron intake 24 hour Measured                             |
| HKQuantityTypeIdentifierDietaryThiamin            | social-history            | http://loinc.org          | 81928-4                 | Vitamin B1 (Thiamine) intake 24 hour Measured            |
| HKQuantityTypeIdentifierDietaryRiboflavin         | social-history            | http://loinc.org          | 81071-3                 | Vitamin B2 (Riboflavin) intake 24 hour Measured          |
| HKQuantityTypeIdentifierDietaryVitaminC           | social-history            | http://loinc.org          | 81067-1                 | Vitamin B3 (Niacin) intake 24 hour Measured              |
| HKQuantityTypeIdentifierDietaryFolate             | social-history            | http://loinc.org          | 81134-9                 | Vitamin B9 (Folate) intake 24 hour Measured              |
| HKQuantityTypeIdentifierDietaryBiotin             | social-history            | http://loinc.org          | 81018-4                 | Vitamin B7 (Biotin) intake 24 hour Measured              |
| HKQuantityTypeIdentifierDietaryPantothenicAcid    | social-history            | http://loinc.org          | 81069-7                 | Vitamin B5 (Pantothenate) intake 24 hour Measured        |
| HKQuantityTypeIdentifierDietaryPhosphorus         | social-history            | http://loinc.org          | 81946-6                 | Phosphorus intake 24 hour Measured                       |
| HKQuantityTypeIdentifierDietaryIodine             | social-history            | http://loinc.org          | 81004-4                 | Iodine intake 24 hour Measured                           |
| HKQuantityTypeIdentifierDietaryMagnesium          | social-history            | http://loinc.org          | 81006-9                 | Magnesium intake 24 hour Measured                        |
| HKQuantityTypeIdentifierDietaryZinc               | social-history            | http://loinc.org          | 81088-7                 | Zinc intake 24 hour Measured                             |
| HKQuantityTypeIdentifierDietarySelenium           | social-history            | http://loinc.org          | 81086-1                 | Selenium intake 24 hour Measured                         |
| HKQuantityTypeIdentifierDietaryCopper             | social-history            | http://loinc.org          | 81208-3                 | Copper intake 24 hour Measured                           |
| HKQuantityTypeIdentifierDietaryManganese          | social-history            | http://loinc.org          | 81008-5                 | Manganese intake 24 hour Measured                        |
| HKQuantityTypeIdentifierDietaryChromium           | social-history            | http://loinc.org          | 81024-2                 | Chromium intake 24 hour Measured                         |
| HKQuantityTypeIdentifierDietaryMolybdenum         | social-history            | http://loinc.org          | 81085-3                 | Molybdenum intake 24 hour Measured                       |
| HKQuantityTypeIdentifierDietaryChloride           | social-history            | http://loinc.org          | 80983-0                 | Chloride intake 24 hour Measured                         |
| HKQuantityTypeIdentifierDietaryPotassium          | social-history            | http://loinc.org          | 81009-3                 | Potassium intake 24 hour Measured                        |
| HKQuantityTypeIdentifierDietaryCaffeine           | social-history            | http://loinc.org          | 80490-6                 | Caffeine intake 24 hour Measured                         |
{: .grid}

### FHIR Observation Mapping Template

The following is a template used for implementing the mapping described above.

```
    { {
        "resourceType": "Observation",
        "id": "UUID generated by server during mapping",
        "meta": {
            "profile" : ["http://cardinalkit.org/fhir/StructureDefinition/ck_mhealth_observation_profile"],
            "source": "cardinalKitApp"
        },
        "identifier"  : [{
            "system" : "http://cardinalkit.org/fhir/ids",
            "value" : *header.id* // id from the data point's header
        }],
        "status": "final",
        "category": [
            {
            "coding": [{
                "system": "http://hl7.org/fhir/observation-category",
                "code": *Observation Category Code*,
                "display": *Observation Category Display*
                }]
            }
        ],
        "code": {
            "coding": [{
                "system": *Observation Coding System*,
                "code": *Observation Coding Code*,
                "display": *Observation Coding Display*
            }]
        },
        "subject": {
            "identifier" : {
                "system" : "http://cardinalkit.org/fhir/patient_ids",
                "value" : *header.user_id*
                }
        },
        "effectiveDateTime" : *body.effective_time_frame.date_time*, // used for data points with a single date/time
        "effectivePeriod" : { // used for data points with a time interval
            "start" : *body.effective_time_frame.time_interval.start_date_time*,
            "end" : *body.effective_time_frame.time_interval.end_date_time*
            },
        "issued": *header.creation_date_time*,
        "valueQuantity" : {
            "value" : *Value Quantity Value*,
            "unit" : *Value Quantity Unit*,
            "system" : *Value Quantity System*,
            "code" : *Value Quantity Code*
        },
        "device" : {
        "extension" : [{
            "url" : "http://cardinalkit.org/fhir/StructureDefinition/omh_fhir_observation_device_modality",
            "valueCode" : *header.acquisition_provenance.modality*
        }],
        "display" : *header.acquisition_provenance.source_name*
        },
        "component": [{ // this property is used if the data point has multiple components (see component table above).
            "code" : {
                "coding" : [{
                    "system": "http://fhir.org/guides/omhtofhir/omh_fhir_observation_codes,
                    "code": *Component Coding Code*,
                    "display": *Component Coding Display*
                }],
            },
            "valueCodeableConcept": {
                "coding": [{
                    "system": *Component Value System*,
                    "code": *Component Value Code*,
                    "display": *Component Value Display*,
                }],
                "text": *Component Value Text*,
            },
            "valueQuantity": {
                "value": *Component Value Quantity Value*,
                "unit": *Component Value Quantity Unit*,
                "system": *Component Value Quantity System*,
                "code": *Component Value Quantity Code*
            }
        }
    }
```
Please see the [Examples](5_examples.html) page for a complete example mapping.