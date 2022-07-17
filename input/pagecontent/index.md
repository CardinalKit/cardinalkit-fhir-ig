### Background

[CardinalKit](https://cardinalkit.org) is an open-source digital health mobile app framework consisting of an iOS mobile application template, Google Cloud managed backend, and web-based data dashboard. CardinalKit makes it easy to build a mobile application that collects patient-generated health data, including from wearable devices (e.g. Apple Watch, Fitbit), and represent these data in standardized formats. This Implementation Guide describes how CardinalKit represents mobile health data as FHIR resources.

### Data Workflow

CardinalKit iOS applications collect data from devices compatible with Apple [HealthKit](https://developer.apple.com/documentation/healthkit) which is a centralized repository for health and fitness data on the iPhone and Apple Watch. CardinalKit serializes this data into JSON using [Granola](https://github.com/cardinalkit/granola) according to either specialized [Open mHealth](https://www.openmhealth.org/) schemas or generic HealthKit schemas as described in this [mapping table](https://github.com/CardinalKit/Granola/blob/main/Docs/hkobject_type_coverage.md). CardinalKit provides an [OMH-to-FHIR mapper](https://github.com/CardinalKit/CardinalKit-OMH-to-FHIR) which converts these data into FHIR resources, as described in this Implementation Guide. These FHIR resources can then be consumed by FHIR applications.

### Usage

The CardinalKit framework provides a [mapper module](https://github.com/CardinalKit/CardinalKit-OMH-to-FHIR) that can be deployed as a serverless cloud function to Google Cloud and automates OMH to FHIR mapping within the database of your CardinalKit project.

### Publisher

This Implementation Guide was written in FSH, and built with SUSHI and the FHIR Publisher by [Vishnu Ravi](https://profiles.stanford.edu/vishnu-ravi). CardinalKit is a project at the [Stanford Byers Center for Biodesign](https://biodesign.stanford.edu) at [Stanford University](https://stanford.edu/).

### Licensing

While this implementation guide itself is in the public domain, it includes examples making use of terminologies such as SNOMED CT, LOINC, and others that may have more restrictive licensing requirements.