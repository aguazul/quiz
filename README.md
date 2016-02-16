# Overview
This repository provides data required to complete the tasks described below
in a folder called `data`.  These tasks are intended to assess practical
programming skills associated with the role of Sr. Data Analyst.

Fork this repository to your own personal copy and develop as needed.  Add and 
commit all source code files you generate.  When complete, push your changes to 
your fork and submit a pull request for review.


## Task 1
_Develop and document a function to handle "partial dates"_

A partial date is a recorded date value that is missing the day or month 
element, and is commonly encountered in clinical research data.  They are 
typically encoded in a format that is specific to the study and/or the clinical 
research organization.

In the provided dataset, dates are stored as character strings in `YYYY-MM-DD`
format.  Partial dates therein are missing day values which are substituted with
`"XX"`, e.g. `2016-01-XX`.

In order to process data with partial dates, the missing day values must be filled
before use in date comparison operations required for routine reporting.

### Goal:
Develop and document an R function to convert partial dates values to values that
can be used in date comparison operations.

This function should:
- accept dates as a character vector
- fill in the missing day value with `15`, or a user specified value
- return values as objects that can be used in date comparisons


## Task 2:
_Create a data validation report that flags blood sample collection records missing consent_

A critical task of clinical data management is ensuring that the data in a study
database complies with data rules specified by the study protocol.  In this case
patients who have had blood samples collected, should have provided consent on
or prior to the date of sample collection.  Any records that do not meet this
criteria are flagged for review.

There are three tables (provided as CSVs) in the sample data set:
- **exam_dates**:
  Stores patient exam visit dates with columns:
  - patient_id: patient id number
  - visit_id: exam visit id number
  - date: date that the visit occurred; may contain partial date
- **collection**:
  Stores samples collected from patients
  - patient_id: patient id number
  - visit_id: exam visit id number for sample collection
  - type: sample collection type
  - is_collected: boolean flag if specified sample type was collected
- **consents**:
  Stores consents provided by patients
  - patient_id: patient id number
  - category: consent category - e.g. "collection"
  - type: category sub-item for consent
  - date: date that consent was received; provided dates are complete

### Goal:
Develop and document an R script that generates a data validation report.  This
script should perform the following operations:

- Combine (join) the above data tables to align `patient_id`'s with only `"blood"` 
  sample collection dates and only `"blood"` sample consent dates.
- Apply the function you developed in Task #1 to process dates as needed.
- Create a column called `flag` in the combined data set that is `TRUE` if both
  of the following conditions are met:
  - a patient blood sample was collected
  - the date of blood sample consent is not on or before the date of blood 
    sample collection
- Export the combined data set to a CSV file called `report.csv`

