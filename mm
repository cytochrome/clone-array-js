
OUT_DIR    			:= ../out/ls

LS_MODULES 			:= base.modules.meta.ls  base.modules.manager.ls base.modules.main.ls
LS_INPUT 			:= base.lib.ls $(LS_MODULES) exports.ls # base.agent.ls
LS_TEST    			:= test.main.ls

OUTPUT_MAIN 		:= $(OUT_DIR)/all.js
OUTPUT_TEST 		:= $(OUT_DIR)/test.js

OUTPUT_LS_MAIN  	:= $(OUTPUT_MAIN:.js=.ls)
OUTPUT_LS_TEST  	:= $(OUTPUT_TEST:.js=.ls)

OUTPUT_TEST_LSS 	:= $(addprefix $(OUT_DIR)/,$(LS_INPUT:.ls=.js))

OUT_FILES 			:= $(OUTPUT_TEST) $(OUTPUT_MAIN)
OUT_LS_FILES 		:= $(OUT_FILES:.js=.ls) $(OUTPUT_TEST_LSS)
OUT_ALL_FILES 		:= $(OUT_LS_FILES) $(OUT_FILES) 

IN_ALL_FILES 		:= $(LS_INPUT) $(LS_TEST)

$(shell mkdir -p $(OUT_DIR))

.SUFFIXES:
.SUFFIXES: .ls .js

all: $(OUTPUT_MAIN) test

$(OUTPUT_MAIN): $(OUTPUT_LS_MAIN)
	livescript -cbp $(OUTPUT_LS_MAIN) > $@

$(OUTPUT_LS_MAIN): $(LS_INPUT)
	cat $(LS_INPUT) > $@

test: $(OUTPUT_TEST)
	cat $(OUTPUT_TEST) | node

$(OUTPUT_TEST): $(OUTPUT_LS_TEST)
	livescript -cbp $(OUTPUT_LS_TEST) > $@

$(OUTPUT_LS_TEST): $(OUTPUT_TEST_LSS) $(OUTPUT_MAIN)
	cat $(OUTPUT_LS_MAIN) $(LS_TEST) > $@

$(OUT_DIR)/%.js: %.ls
	livescript -cbp $< > $@

clean-swap:
	rm -f $(IN_ALL_FILES:.ls=)

clean: clean-swap
	# remove ls/*.js
	rm -f $(IN_ALL_FILES:.ls=.js)

	# remove ../out/*
	rm -f $(OUT_ALL_FILES)

	rmdir $(OUT_DIR)

