CHANGELOG := "Update"

default:
	@echo "No Default make command configured"
	@echo "Please use either"
	@echo "   - make curseforge"
	@echo "   - make modrinth"
	@echo "   - make prism"
	@echo "   - make technic"
	@echo "   - make all"
	@echo ""
	@echo "Curseforge will make a curseforge compatible zip"
	@echo ""
	@echo "Modrinth will make a Modrinth compatible mrpack"
	@echo ""
	@echo "prism will make a prism zip file which contains the packwiz updater."
	@echo ""
	@echo "Technic will make a Technic pack zip"
	@echo ""
	@echo "All will make all packs it can"
	@echo ""
	
curseforge:
	@echo "Making ${GAME_VERSION} Curseforge pack"
	-mkdir build
	cd build && packwiz curseforge export --pack-file ../pack/${GAME_VERSION}/pack.toml

modrinth:
	@echo "Making ${GAME_VERSION} Modrinth pack"
	-mkdir build
	cd build && packwiz modrinth export --pack-file ../pack/${GAME_VERSION}/pack.toml

quilt-server:
	@echo "Making Server pack"
	wget -nc https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/latest/quilt-installer-latest.jar -P build
	cd build && java -jar quilt-installer-latest.jar \
  	install server ${GAME_VERSION} \
  	--download-server
	-rm build/quilt-installer-latest.jar
	-cp -r ./server ./build/server

release:
	sed -i -e '/version =/ s/= .*/= "${VERSION}"/' pack/pack.toml
	make modrinth
	CHANGELOG=${CHANGELOG} GAME_VERSION=${GAME_VERSION} MODRINTH_TOKEN=${MODRINTH_TOKEN} gradle modrinth

clean:
	-rm -rf build/
	-sed -i -e '/version =/ s/= .*/= "${VERSION}"/' pack/pack.toml
	-git gc --aggressive --prune

update:
	go install github.com/packwiz/packwiz@latest

all: curseforge modrinth prism server clean