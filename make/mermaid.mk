# markdown-and-pandoc-essentials.md: images/class-diagram.png

%.png: %.mmd
	mmdc -q -i $< -o $@ -s 4