# Gantt Charts - LaTeX Build Pipeline
# ====================================

# Configuration
BUILD_DIR   := build
OUTPUT_DIR  := output
REPORTS_DIR := reports
LATEX_ENGINE := -pdflua

# Chart documents (add new charts here)
CHARTS := planr precious-bodily-fluids wing-attack-plan operation-dropkick

# latexmk options
LATEXMK_OPTS := $(LATEX_ENGINE) \
	-output-directory=$(BUILD_DIR) \
	-shell-escape \
	-interaction=nonstopmode \
	-file-line-error

# Find all source files for dependency tracking
TEX_FILES := $(wildcard *.tex) $(wildcard Settings/*.tex) $(wildcard Charts/*.tex)

# Default target
.DEFAULT_GOAL := help

##@ Build Targets

pdf: $(OUTPUT_DIR)/planr.pdf ## Build Plan R Gantt chart

charts: $(foreach c,$(CHARTS),$(OUTPUT_DIR)/$(c).pdf) ## Build all charts

$(OUTPUT_DIR)/%.pdf: %.tex $(TEX_FILES) | $(BUILD_DIR) $(OUTPUT_DIR)
	@echo "Building $*.pdf..."
	@latexmk $(LATEXMK_OPTS) $<
	@cp $(BUILD_DIR)/$*.pdf $(OUTPUT_DIR)/
	@echo "Output: $(OUTPUT_DIR)/$*.pdf"

watch: | $(BUILD_DIR) $(OUTPUT_DIR) ## Continuous build on file changes
	@echo "Watching for changes (Ctrl+C to stop)..."
	@latexmk $(LATEXMK_OPTS) -pvc planr.tex

##@ Cleanup

clean: ## Remove build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Done."

distclean: clean ## Remove all generated files
	@echo "Removing output files..."
	@rm -rf $(OUTPUT_DIR)
	@echo "Done."

##@ Directories

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

##@ Reports (Pandoc)

# Find all report projects (*-report.md files)
REPORT_SOURCES := $(wildcard $(REPORTS_DIR)/*-report.md)
REPORT_PROJECTS := $(patsubst $(REPORTS_DIR)/%-report.md,%,$(REPORT_SOURCES))

report: ## Build all PDF reports
	@for proj in $(REPORT_PROJECTS); do \
		$(MAKE) -C $(REPORTS_DIR) pdf PROJECT=$$proj; \
	done

report-%: ## Build reports
	@$(MAKE) -C $(REPORTS_DIR) pdf PROJECT=$*

report-clean: ## Clean report build artifacts
	@$(MAKE) -C $(REPORTS_DIR) clean

##@ Utilities

all: pdf report ## Build everything (charts + reports)

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
		/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

.PHONY: pdf charts watch clean distclean help all report report-clean
