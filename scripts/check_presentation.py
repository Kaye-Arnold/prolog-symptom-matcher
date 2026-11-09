#!/usr/bin/env python3
"""Validate the generated PowerPoint package, slide content, and source links."""
from pathlib import Path
from zipfile import ZipFile

from lxml import etree
from pptx import Presentation

ROOT = Path(__file__).resolve().parents[1]
PPTX = ROOT / "presentation" / "project-presentation.pptx"
EXPECTED_LINKS = {
    "https://www.who.int/news-room/fact-sheets/detail/malaria",
    "https://www.who.int/news-room/fact-sheets/detail/influenza-(seasonal)",
    "https://www.who.int/news-room/fact-sheets/detail/measles",
    "https://www.cdc.gov/common-cold/about/index.html",
}
REQUIRED_TEXT = (
    "usually_dry",
    "TIE at 3/6",
    "Common cold 4/8",
    "180",
    "Windows",
    "NO DIAGNOSIS",
)

assert PPTX.is_file() and PPTX.stat().st_size > 0, "PPTX missing or empty"
prs = Presentation(PPTX)
assert len(prs.slides) == 10, f"expected 10 slides, found {len(prs.slides)}"

all_text = []
for slide_number, slide in enumerate(prs.slides, 1):
    slide_text = []
    for shape in slide.shapes:
        assert shape.left >= 0 and shape.top >= 0, (slide_number, shape.name, "negative position")
        assert shape.left + shape.width <= prs.slide_width + 1, (slide_number, shape.name, "right overflow")
        assert shape.top + shape.height <= prs.slide_height + 1, (slide_number, shape.name, "bottom overflow")
        if getattr(shape, "has_text_frame", False):
            slide_text.append(shape.text)
    assert any(text.strip() for text in slide_text), f"slide {slide_number} has no text"
    all_text.extend(slide_text)

combined_text = "\n".join(all_text).lower()
for phrase in REQUIRED_TEXT:
    assert phrase.lower() in combined_text, f"required content missing: {phrase}"

with ZipFile(PPTX) as package:
    names = set(package.namelist())
    assert "ppt/presentation.xml" in names
    assert all(f"ppt/slides/slide{i}.xml" in names for i in range(1, 11))
    for name in names:
        if name.endswith((".xml", ".rels")):
            etree.fromstring(package.read(name))
    relationships = "\n".join(
        package.read(name).decode("utf-8")
        for name in names
        if name.endswith(".rels")
    )
    for url in EXPECTED_LINKS:
        assert url in relationships, f"source hyperlink missing: {url}"

print(
    f"PASS - {len(prs.slides)} slides, well-formed PPTX XML, "
    f"{len(EXPECTED_LINKS)} external source links, required content present, "
    "all shapes within slide bounds."
)
