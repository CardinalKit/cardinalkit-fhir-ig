# CardinalKit FHIR Implementation Guide

This repository contains a FHIR Implementation Guide created with [FHIR Shorthand](https://fshschool.org/docs/), [SUSHI](https://github.com/FHIR/sushi), and the [FHIR IG Publisher](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation).

## Requirements
- Node.js/npm
- Jekyll
- JDK

## Instructions
1. In the root directory, run `_updatePublisher.sh` on MacOS/Linux or `_updatePublisher.bat` on Windows to download the FHIR IG Publisher JAR.
2. Now, run `_genonce.sh` on MacOS/Linux or `_genonce.bat` on Windows to generate the Implementation Guide HTML.
3. The output will be in the `output` directory. Open the `index.html` file in a web browser to view the Implementation Guide.

## Editing

The `input/fsh` folder contains the Profiles defined in this IG, written in FHIR Shorthand (FSH). The narrative content is found in `input/pagecontent` in Markdown format. Global configuration is done in `sushi-config.yaml` in the root of the directory. 

## Authors
Vishnu Ravi (@vishnuravi)
