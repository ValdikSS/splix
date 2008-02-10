#
#	rules.mk			(C) 2007-2008, Aurélien Croc (AP²C)
#
#  Compilation rules file for SpliX
#

$(rastertoqpdl_TARGET): $(rastertoqpdl_OBJ)
	$(call printCmd, $(cmd_link))
	$(Q)g++ -o $@ $^ $(rastertoqpdl_CXXFLAGS) $(rastertoqpdl_LDFLAGS) \
		$(rastertoqpdl_LIBS)

$(pstoqpdl_TARGET): $(pstoqpdl_OBJ)
	$(call printCmd, $(cmd_link))
	$(Q)g++ -o $@ $^ $(pstoqpdl_CXXFLAGS) $(pstoqpdl_LDFLAGS) \
		$(pstoqpdl_LIBS)

.PHONY: install
cmd_install_raster	= INSTALL           $(rastertoqpdl_TARGET)
cmd_install_ps		= INSTALL           $(pstoqpdl_TARGET)
install: $(rastertoqpdl_TARGET) $(pstoqpdl_TARGET)
	$(Q)mkdir -p $(DESTDIR)${CUPSFILTER}
	$(call printCmd, $(cmd_install_raster))
	$(Q)install -m 655 -s $(rastertoqpdl_TARGET) $(DESTDIR)${CUPSFILTER}
	$(call printCmd, $(cmd_install_ps))
	$(Q)install -m 655 -s $(pstoqpdl_TARGET) $(DESTDIR)${CUPSFILTER}
	$(Q)$(MAKE) --no-print-directory -C ppd install Q=$(Q) \
		DESTDIR=$(abspath $(DESTDIR))
	@echo ""
	@echo "             --- Everything is done! Have fun ---"
	@echo ""



# Specific rules used for development and information

.PHONY: tags optionList
tags:
	ctags --recurse --language-force=c++ --extra=+q --fields=+i \
	      --exclude=doc --exclude=.svn * 


ifneq ($(DISABLE_JBIG),0)
JBIGSTATE := disabled
else
JBIGSTATE := enabled
endif
ifneq ($(DISABLE_THREADS),0)
THREADSSTATE := disabled
else
THREADSSTATE := enabled
endif
ifneq ($(DISABLE_BLACKOPTIM),0)
BLACKOPTIMSTATE := disabled
else
BLACKOPTIMSTATE := enabled
endif


MSG	:=    +---------------------------------------------+\n
MSG	+=    |      COMPILATION PARAMETERS SUMMARY         |\n
MSG	+=    +---------------------------------------------+\n
MSG	+=    |      THREADS     = %8s                 |\n
MSG	+=    |      THREADS Nr  = %8i                 |\n
MSG	+=    |      CACHESIZE   = %8i                 |\n
MSG	+=    |      JBIG        = %8s                 |\n
MSG	+=    |      BLACK OPTIM = %8s                 |\n
MSG	+=    +---------------------------------------------+\n
MSG	+=   (Do a \"make clean\" before updating these values)\n\n
optionList:
	@printf " $(MSG)" $(THREADSSTATE) $(THREADS) $(CACHESIZE) $(JBIGSTATE) \
		$(BLACKOPTIMSTATE)
