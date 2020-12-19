all: build

build: project
	@echo "\n"
	@read -r -p "Enter the test file input: " arxeio_eisodou; \
	./a.out $$arxeio_eisodou
	@echo "<<__________END___________>>\n\n"

project: project_arxes_l project_arxes_y 
	gcc project_arxes.tab.c lex.yy.c

project_arxes_l: project_arxes.y
	bison -d project_arxes.y

project_arxes_y: project_arxes.l
	flex project_arxes.l
