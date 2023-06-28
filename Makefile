DEFAULT = org.deepin.demo
PREFIX := /opt/apps/$(DEFAULT)/files
TARGET = squashfs-root
APPIMAGE = $(shell ls *.AppImage)

.PHONY: all
all: extract install

.PHONY: extract
extract:
	chmod +x $(APPIMAGE)
	./$(APPIMAGE) --appimage-extract

DESKTOP = $(shell cd $(TARGET) && ls *.desktop)
.PHONY: install
install:
	install -d $(PREFIX)/data
	install -d $(PREFIX)/bin
	install -d $(PREFIX)/share/applications
	# AppRun需要运行在自己的目录下, 所以调整入口为AppRun.sh
	echo '#!/bin/bash\n cd $(PREFIX)/data/ && ./AppRun \$@' > $(PREFIX)/bin/AppRun.sh
	chmod +x $(PREFIX)/bin/AppRun.sh
	cp -rp $(TARGET)/* $(PREFIX)/data
	sed -i "s/Exec=.*/Exec=AppRun.sh/" $(PREFIX)/data/$(DESKTOP)
	#cd $(PREFIX)/bin && ln -s ../data/AppRun AppRun
	cd $(PREFIX)/share/applications && ln -s ../../data/$(DESKTOP) $(DESKTOP)

.PHONY: clean
clean:
	rm -r $(TARGET)
	rm -r .linglong-target
