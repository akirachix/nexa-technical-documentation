# Reference data

Cost estimation uses Markdown reference files as background. The notebook `zamline_reference_files` generates them from source documents and structured datasets. The notebook, the source documents and the datasets are not part of this documentation repository; this page describes how the notebook is documented to work.

## What the notebook produces

It writes one Markdown file per source document, with a source header and `## Page N` markers so extracted information can be traced to the corresponding PDF page. It also writes Markdown summaries for five structured datasets. The original CSV files are not changed.

### Notebook steps

1. Read the source list `zamline_core_sources.csv` and match each source to its PDF in `01_Raw_Documents`. Sources without a PDF are reported as missing and are not replaced with other copies.
2. Skip exact duplicate PDFs using a SHA-256 checksum, and flag unreadable PDFs.
3. Extract text page by page. OCR (Tesseract, at 220 DPI) runs only on pages with fewer than 200 characters of text. OCR output replaces the text layer only when it adds text with a mean confidence of at least 60.
4. Clean the text. A line is removed only if it is a page label, a page number at the top or bottom of a page, or a header or footer repeated on at least 40 percent of pages. Hyphenated words and broken lines are rejoined. Wording and numbers are not changed. Numbers are counted before and after cleaning so that any lost figure appears in the quality report.
5. Write one `.md` file per document.
6. Validate the structured datasets (size, missing values, duplicate rows) and write short summaries.
7. Write the manifest and quality reports.

### Structured datasets

The notebook lists D01, D02, D04, D05 and D06. There is no D03.

| ID | File | Notes |
|---|---|---|
| D01 | `SCMS_Raw_Global_Shipment_History_10324_Rows.csv` | Raw export |
| D02 | `SCMS_Cleaned_African_Truck_Freight_1160_Rows.csv` | Truck shipments only, with positive freight cost and weight. Checked against D01. |
| D04 | `WorldBank_Zambia_Trucking_Cost_Factors_2007_Derived.csv` | Historical |
| D05 | `WorldBank_Zambia_Road_Freight_Market_Context_2005_2008_Derived.csv` | Historical |
| D06 | `NRFA_Zambia_Heavy_Vehicle_Toll_Rates_Effective_2026-01-01.csv` | Official toll rates, effective 2026-01-01 |

### Outputs

The notebook writes to the folder `ZamLine_Data_Review/reference_files`.

| File | Purpose |
|---|---|
| One `.md` per document and per structured summary | The files uploaded to the Gemini Files API |
| `manifest.json` | Lists every reference file with source details, for the backend upload script |
| `manifest.csv` | The same data for spreadsheet review |
| `quality_report.csv` | Per-document warnings |
| `structured_validation.csv` | Dataset checks |

Quality warnings are: PDF missing, very short, OCR used, mostly graphics, and numbers lost. The "numbers lost" warning should never appear.

## Running the notebook

- **Prerequisites:** the Python packages `pymupdf`, `pytesseract`, `Pillow`, `pandas` and `tabulate` (the first cell installs any that are missing), and the Tesseract binary. In Colab the Tesseract install is automatic. Elsewhere, install it yourself, otherwise pages that need OCR are flagged.
- **Folder layout:** a `ZamLine_Data` folder containing `zamline_core_sources.csv`, `01_Raw_Documents` and `06_Structured_Data`. In Colab it is read from `/content/drive/MyDrive/ZamLine_Data`. Locally, the project root is the current folder, or its parent when the current folder is named `ZamLine_Data_Review`.
- **Settings:** only the Settings cell should need editing (paths, `MIN_CHARS_PER_PAGE`, `OCR_DPI`, `OCR_MIN_CONFIDENCE`, document notes, dataset file names).
- **Run:** execute all cells from top to bottom. The OCR step takes several minutes.
- **Verify:** check the warnings column of the quality report and spot-check a cleaned document. The notebook defaults to DOC018.
