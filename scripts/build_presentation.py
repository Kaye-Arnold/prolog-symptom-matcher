#!/usr/bin/env python3
"""Build the review-branch project presentation (python-pptx 1.0.2)."""
from pathlib import Path

from pptx import Presentation
from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_CONNECTOR, MSO_SHAPE
from pptx.enum.text import MSO_ANCHOR, PP_ALIGN
from pptx.util import Inches, Pt

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "presentation" / "project-presentation.pptx"

# Calm, high-contrast academic palette. No external artwork is embedded.
NAVY = "142B3A"
INK = "193645"
TEAL = "138A83"
MINT = "DDF3EC"
PALE = "F3F7F5"
PAPER = "FFFFFF"
GOLD = "E7B54A"
PALE_GOLD = "FBF1D8"
CORAL = "C95D4B"
PALE_CORAL = "F9E6E0"
MID = "5D727C"
LINE = "D9E3E1"

prs = Presentation()
prs.slide_width = Inches(13.333)
prs.slide_height = Inches(7.5)
prs.core_properties.title = "Knowledge-Based Symptom-Matching System"
prs.core_properties.subject = "Logic Programming project presentation"
prs.core_properties.author = "Project team — names and roles pending confirmation"
prs.core_properties.keywords = "Prolog, logic programming, knowledge representation, educational prototype"
prs.core_properties.comments = (
    "Review-branch presentation. Scope approval, Windows re-verification, "
    "oral defense, video upload and final submission remain pending."
)

BLANK = prs.slide_layouts[6]


def rgb(hex_value):
    return RGBColor.from_string(hex_value)


def add_bg(slide, color=PALE):
    fill = slide.background.fill
    fill.solid()
    fill.fore_color.rgb = rgb(color)


def textbox(slide, x, y, w, h, text, size=18, color=INK, bold=False,
            font="Aptos", align=PP_ALIGN.LEFT, valign=MSO_ANCHOR.TOP,
            margin=0.03, italic=False, break_line=False):
    shape = slide.shapes.add_textbox(Inches(x), Inches(y), Inches(w), Inches(h))
    tf = shape.text_frame
    tf.clear()
    tf.word_wrap = True
    tf.margin_left = Inches(margin)
    tf.margin_right = Inches(margin)
    tf.margin_top = Inches(margin)
    tf.margin_bottom = Inches(margin)
    tf.vertical_anchor = valign
    p = tf.paragraphs[0]
    p.alignment = align
    p.space_before = Pt(0)
    p.space_after = Pt(0)
    p.text = text
    for run in p.runs:
        run.font.name = font
        run.font.size = Pt(size)
        run.font.bold = bold
        run.font.italic = italic
        run.font.color.rgb = rgb(color)
    return shape


def richline(slide, x, y, w, h, parts, size=18, align=PP_ALIGN.LEFT,
             valign=MSO_ANCHOR.MIDDLE, margin=0.03):
    shape = slide.shapes.add_textbox(Inches(x), Inches(y), Inches(w), Inches(h))
    tf = shape.text_frame
    tf.clear()
    tf.word_wrap = True
    tf.margin_left = Inches(margin)
    tf.margin_right = Inches(margin)
    tf.margin_top = Inches(margin)
    tf.margin_bottom = Inches(margin)
    tf.vertical_anchor = valign
    p = tf.paragraphs[0]
    p.alignment = align
    p.space_after = Pt(0)
    for text, color, bold, italic in parts:
        run = p.add_run()
        run.text = text
        run.font.name = "Aptos"
        run.font.size = Pt(size)
        run.font.color.rgb = rgb(color)
        run.font.bold = bold
        run.font.italic = italic
    return shape


def card(slide, x, y, w, h, fill=PAPER, line=LINE, radius=True):
    shape_kind = MSO_SHAPE.ROUNDED_RECTANGLE if radius else MSO_SHAPE.RECTANGLE
    shape = slide.shapes.add_shape(shape_kind, Inches(x), Inches(y), Inches(w), Inches(h))
    shape.fill.solid()
    shape.fill.fore_color.rgb = rgb(fill)
    shape.line.color.rgb = rgb(line)
    shape.line.width = Pt(1)
    if radius:
        shape.adjustments[0] = 0.12
    return shape


def pill(slide, x, y, w, text, fill=MINT, color=TEAL, size=11):
    shape = slide.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE,
                                   Inches(x), Inches(y), Inches(w), Inches(0.34))
    shape.fill.solid()
    shape.fill.fore_color.rgb = rgb(fill)
    shape.line.fill.background()
    shape.adjustments[0] = 0.18
    textbox(slide, x + 0.06, y + 0.015, w - 0.12, 0.27, text, size=size,
            color=color, bold=True, align=PP_ALIGN.CENTER,
            valign=MSO_ANCHOR.MIDDLE, margin=0)


def dot(slide, x, y, color=TEAL, diameter=0.12):
    shape = slide.shapes.add_shape(MSO_SHAPE.OVAL, Inches(x), Inches(y),
                                   Inches(diameter), Inches(diameter))
    shape.fill.solid()
    shape.fill.fore_color.rgb = rgb(color)
    shape.line.fill.background()
    return shape


def line(slide, x1, y1, x2, y2, color=LINE, width=1.4):
    shape = slide.shapes.add_connector(MSO_CONNECTOR.STRAIGHT,
                                       Inches(x1), Inches(y1),
                                       Inches(x2), Inches(y2))
    shape.line.color.rgb = rgb(color)
    shape.line.width = Pt(width)
    return shape


def footer(slide, n, light=False):
    color = "B8C9CF" if light else MID
    line(slide, 0.55, 7.12, 12.78, 7.12,
         "31505D" if light else LINE, 0.8)
    textbox(slide, 0.62, 7.17, 8.7, 0.19,
            "LOGIC PROGRAMMING  •  REVIEW BRANCH  •  EDUCATIONAL PROTOTYPE",
            size=8.5, color=color, bold=True, valign=MSO_ANCHOR.MIDDLE, margin=0)
    textbox(slide, 12.15, 7.15, 0.55, 0.22, f"{n:02d} / 10", size=9,
            color=color, bold=True, align=PP_ALIGN.RIGHT,
            valign=MSO_ANCHOR.MIDDLE, margin=0)


def heading(slide, section, title, subtitle=None, n=None):
    pill(slide, 0.62, 0.38, max(1.25, len(section) * 0.105), section.upper(),
         fill=MINT, color=TEAL, size=9.5)
    textbox(slide, 0.62, 0.84, 12.0, 0.60, title, size=30, color=NAVY,
            bold=True, valign=MSO_ANCHOR.MIDDLE, margin=0)
    if subtitle:
        textbox(slide, 0.66, 1.47, 11.9, 0.35, subtitle, size=13.5,
                color=MID, valign=MSO_ANCHOR.MIDDLE, margin=0)
    if n is not None:
        footer(slide, n)


def add_round_text(slide, x, y, w, h, title, body, accent=TEAL,
                   fill=PAPER, title_size=17, body_size=13.4):
    card(slide, x, y, w, h, fill=fill)
    shape = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, Inches(x), Inches(y + 0.17),
                                   Inches(0.055), Inches(h - 0.34))
    shape.fill.solid()
    shape.fill.fore_color.rgb = rgb(accent)
    shape.line.fill.background()
    textbox(slide, x + 0.22, y + 0.19, w - 0.4, 0.36, title,
            size=title_size, color=NAVY, bold=True, valign=MSO_ANCHOR.MIDDLE)
    textbox(slide, x + 0.22, y + 0.61, w - 0.4, h - 0.76, body,
            size=body_size, color=INK, valign=MSO_ANCHOR.TOP, margin=0.04)


# 1 — Title
s = prs.slides.add_slide(BLANK)
add_bg(s, NAVY)
# Decorative geometry, intentionally native PowerPoint shapes.
for i, c in enumerate((TEAL, "236B70", "294C5B")):
    sh = s.shapes.add_shape(MSO_SHAPE.OVAL,
                            Inches(9.25 + i * 0.55), Inches(0.5 + i * 0.6),
                            Inches(2.5 - i * 0.25), Inches(2.5 - i * 0.25))
    sh.fill.solid(); sh.fill.fore_color.rgb = rgb(c); sh.fill.transparency = 10
    sh.line.fill.background()
pill(s, 0.74, 0.68, 2.1, "LOGIC PROGRAMMING", fill="244551", color="A7E4D7", size=10)
textbox(s, 0.76, 1.38, 8.45, 1.58,
        "Knowledge-Based\nSymptom Matching", size=38, color=PAPER, bold=True,
        valign=MSO_ANCHOR.MIDDLE, margin=0)
textbox(s, 0.79, 3.18, 8.6, 0.68,
        "A source-linked Prolog list-comparison prototype", size=21,
        color="BBD2D7", valign=MSO_ANCHOR.MIDDLE, margin=0)
line(s, 0.79, 4.12, 8.15, 4.12, "42616B", 1.2)
textbox(s, 0.8, 4.35, 7.9, 0.46,
        "Facts  ·  Rules  ·  Queries  ·  Exact list comparison",
        size=16, color=PAPER, valign=MSO_ANCHOR.MIDDLE, margin=0)
card(s, 0.78, 5.25, 8.45, 0.9, fill="3C3530", line="806A42")
textbox(s, 1.0, 5.38, 8.0, 0.54,
        "EDUCATIONAL ONLY — no diagnosis, probabilities, treatment or urgency",
        size=15.5, color="F4D88E", bold=True, valign=MSO_ANCHOR.MIDDLE, margin=0.02)
textbox(s, 9.25, 4.2, 3.2, 1.32,
        "Four proposed\ncondition profiles", size=22, color=PAPER, bold=True,
        align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 9.28, 5.6, 3.15, 0.55,
        "Scope review pending", size=13, color="BBD2D7", bold=True,
        align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
footer(s, 1, light=True)

# 2 — Problem and scope
s = prs.slides.add_slide(BLANK); add_bg(s)
heading(s, "01 · Problem", "A small, explainable knowledge-based system",
        "The assignment asks for declarative knowledge, inference, queries, and tested interaction.", 2)
profiles = [
    (0.72, "Malaria", "WHO source list"),
    (3.06, "Seasonal influenza", "WHO source list"),
    (5.40, "Measles", "WHO source list"),
    (7.74, "Common cold", "CDC source list"),
]
for x, title, source in profiles:
    card(s, x, 2.22, 2.15, 1.25, fill=PAPER)
    dot(s, x + 0.2, 2.5, TEAL)
    textbox(s, x + 0.42, 2.35, 1.52, 0.46, title, size=16,
            color=NAVY, bold=True, valign=MSO_ANCHOR.MIDDLE)
    textbox(s, x + 0.2, 2.92, 1.75, 0.3, source, size=11.5,
            color=MID, valign=MSO_ANCHOR.MIDDLE)
card(s, 10.15, 2.22, 2.48, 1.25, fill=PALE_GOLD, line="E7D7AC")
textbox(s, 10.37, 2.39, 2.05, 0.32, "SCOPE STATUS", size=10,
        color="8B6820", bold=True, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 10.37, 2.75, 2.05, 0.49, "Proposed; human\nreview pending", size=16,
        color=NAVY, bold=True, valign=MSO_ANCHOR.MIDDLE)
add_round_text(s, 0.72, 4.03, 3.78, 1.7, "Represent knowledge",
               "Source-linked facts keep each canonical feature attached to its provenance and qualification.",
               accent=TEAL, title_size=17, body_size=13.5)
add_round_text(s, 4.78, 4.03, 3.78, 1.7, "Explain every result",
               "Show shared terms, unmatched recognised terms, unknown terms, and exact fractions.",
               accent=GOLD, title_size=17, body_size=13.5)
add_round_text(s, 8.85, 4.03, 3.78, 1.7, "Stay within bounds",
               "This is a programming exercise—not diagnosis, probability, treatment, or triage.",
               accent=CORAL, fill=PALE_CORAL, title_size=17, body_size=13.5)
textbox(s, 0.75, 6.23, 11.8, 0.42,
        "The assignment PDF does not prescribe this illness set or a console interface.",
        size=13, color=MID, italic=True, valign=MSO_ANCHOR.MIDDLE)

# 3 — Sources and knowledge
s = prs.slides.add_slide(BLANK); add_bg(s)
heading(s, "02 · Knowledge", "Source pages inform facts — not the ranking rule",
        "The comparison algorithm is an application choice; no source validates it as a health measure.", 3)
source_cards = [
    (0.75, 2.18, "WHO · MALARIA", "Fever, headache, chills are among early symptoms.", "Page date: 4 Dec 2025", TEAL),
    (6.82, 2.18, "WHO · INFLUENZA", "Cough is described as usually dry; onset can be sudden.", "Page date: 28 Feb 2025", GOLD),
    (0.75, 4.08, "WHO · MEASLES", "Early symptoms include fever, running nose and cough.", "Page date: 15 Jul 2026", CORAL),
    (6.82, 4.08, "CDC · COMMON COLD", "Fever is usually low grade in older children and adults.", "Updated/reviewed: 19 Feb 2026", "4C85A6"),
]
for x, y, title, body, date, accent in source_cards:
    add_round_text(s, x, y, 5.74, 1.48, title, body + "\n" + date,
                   accent=accent, title_size=14, body_size=12.3)
card(s, 0.78, 6.04, 11.62, 0.53, fill=PALE_GOLD, line="E7D7AC")
textbox(s, 1.0, 6.11, 11.2, 0.34,
        "Qualifications are stored with facts; the program does not interpret severity, age, onset or duration.",
        size=12.4, color="6F571F", bold=True, valign=MSO_ANCHOR.MIDDLE)

# 4 — Representation and alias
s = prs.slides.add_slide(BLANK); add_bg(s)
heading(s, "03 · Representation", "One canonical feature, one source-qualified fact",
        "Preserve the source qualification without counting aliases as extra evidence.", 4)
card(s, 0.78, 2.12, 6.3, 2.0, fill=NAVY, line=NAVY)
pill(s, 1.04, 2.35, 1.56, "PROLOG FACT", fill="244551", color="A7E4D7", size=9.5)
textbox(s, 1.05, 2.94, 5.72, 0.72,
        "condition_symptom(influenza, cough,\n                       usually_dry, who_influenza).",
        size=17.5, color=PAPER, bold=True, font="Aptos Mono",
        valign=MSO_ANCHOR.MIDDLE, margin=0.02)
textbox(s, 1.06, 3.72, 5.62, 0.24,
        "Condition · canonical feature · qualifier · source ID",
        size=11.5, color="BBD2D7", valign=MSO_ANCHOR.MIDDLE)
# Alias path
card(s, 7.65, 2.18, 4.74, 1.12, fill=PALE_GOLD, line="E7D7AC")
textbox(s, 7.93, 2.31, 1.55, 0.32, "dry_cough", size=16, color=NAVY,
        bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 9.51, 2.31, 0.9, 0.32, "ALIASES TO", size=9.5, color=MID,
        bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 10.45, 2.31, 1.5, 0.32, "cough", size=16, color=TEAL,
        bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 7.97, 2.72, 4.05, 0.35,
        "Input synonyms resolve to one canonical feature.", size=12.1,
        color=INK, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
add_round_text(s, 7.65, 3.62, 4.74, 1.44, "Why this matters",
               "Entering both “cough” and “dry cough” cannot add two matches. The qualifier stays attached to the single cough fact.",
               accent=TEAL, title_size=15.5, body_size=12.4)
textbox(s, 0.9, 4.72, 6.02, 1.06,
        "source/5 metadata records a source ID, organisation, title, URL and access date.\n\nOther stored qualifications include sudden_onset, high, small_white and usually_low_grade.",
        size=13.4, color=INK, valign=MSO_ANCHOR.TOP)
card(s, 0.82, 6.12, 11.55, 0.48, fill=MINT, line=MINT)
textbox(s, 1.02, 6.17, 11.1, 0.34,
        "Sourced descriptions are distinct from hand-maintained vocabulary and the software’s comparison rule.",
        size=12, color=TEAL, bold=True, valign=MSO_ANCHOR.MIDDLE)

# 5 — Reasoning pipeline
s = prs.slides.add_slide(BLANK); add_bg(s)
heading(s, "04 · Inference", "A transparent Prolog processing pipeline",
        "Separate stored knowledge, pure list reasoning and console input/output.", 5)
steps = [
    (0.66, "1", "Input", "typed terms", TEAL),
    (2.76, "2", "Normalize", "aliases + unknowns", "4C85A6"),
    (4.86, "3", "Recurse", "dedupe + lists", GOLD),
    (6.96, "4", "Unify", "findall + backtrack", CORAL),
    (9.06, "5", "Compare", "exact N / D", TEAL),
    (11.16, "6", "Explain", "console output", "4C85A6"),
]
for i, (x, num, title, detail, accent) in enumerate(steps):
    card(s, x, 2.42, 1.53, 1.58, fill=PAPER)
    dot(s, x + 0.14, 2.61, accent, 0.32)
    textbox(s, x + 0.14, 2.635, 0.32, 0.24, num, size=10.5, color=PAPER,
            bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE, margin=0)
    textbox(s, x + 0.13, 3.05, 1.27, 0.34, title, size=14.5, color=NAVY,
            bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
    textbox(s, x + 0.12, 3.44, 1.29, 0.42, detail, size=10.5, color=MID,
            align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
    if i < len(steps) - 1:
        line(s, x + 1.59, 3.18, x + 2.04, 3.18, LINE, 2)
        textbox(s, x + 1.71, 3.02, 0.2, 0.32, "›", size=20, color=TEAL,
                bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE, margin=0)
add_round_text(s, 0.78, 4.62, 3.78, 1.26, "Unification + alternatives",
               "A variable matches each fact; backtracking finds other solutions.",
               accent=TEAL, title_size=15, body_size=12.1)
add_round_text(s, 4.78, 4.62, 3.78, 1.26, "Recursion + list processing",
               "normalise_all/2 and dedupe_acc/3 process lists with base and recursive cases.",
               accent=GOLD, title_size=15, body_size=12.1)
add_round_text(s, 8.78, 4.62, 3.78, 1.26, "Narrow negation-as-failure",
               "Used for membership in the finite vocabulary—not to infer absence of illness.",
               accent=CORAL, title_size=15, body_size=12.1)

# 6 — Input handling
s = prs.slides.add_slide(BLANK); add_bg(s)
heading(s, "05 · Input", "Messy input is made visible, not silently scored",
        "Observed from the executed five-case demo; unknown and duplicate handling are separate.", 6)
card(s, 0.78, 2.08, 5.2, 3.94, fill=NAVY, line=NAVY)
pill(s, 1.05, 2.34, 1.72, "RAW INPUT", fill="244551", color="A7E4D7", size=9.5)
textbox(s, 1.06, 2.96, 4.48, 1.06,
        "[High Temperature, fever, headache,\n banana, stuffy nose, fever]",
        size=17, color=PAPER, bold=True, font="Aptos Mono", valign=MSO_ANCHOR.MIDDLE)
line(s, 1.1, 4.18, 5.63, 4.18, "42616B", 1)
textbox(s, 1.1, 4.4, 4.48, 0.39,
        "Normalize aliases • deduplicate • classify unknowns",
        size=12.4, color="BBD2D7", valign=MSO_ANCHOR.MIDDLE)
pill(s, 1.1, 5.15, 1.55, "RECOGNISED", fill="244551", color="A7E4D7", size=9)
textbox(s, 1.1, 5.54, 4.45, 0.31,
        "[fever, headache, nasal_congestion]",
        size=12.7, color=PAPER, bold=True, font="Aptos Mono", valign=MSO_ANCHOR.MIDDLE)
outputs = [
    (6.45, 2.28, "Unknown term", "banana", CORAL, PALE_CORAL),
    (9.42, 2.28, "Duplicate", "fever appears twice", GOLD, PALE_GOLD),
    (6.45, 4.08, "Alias", "stuffy nose → nasal_congestion", TEAL, MINT),
    (9.42, 4.08, "No hidden data", "No patient history is stored", "4C85A6", PAPER),
]
for x, y, title, body, accent, fill in outputs:
    add_round_text(s, x, y, 2.72, 1.38, title, body, accent=accent,
                   fill=fill, title_size=14, body_size=11.8)
card(s, 6.48, 5.71, 5.63, 0.62, fill=PAPER)
textbox(s, 6.66, 5.77, 5.27, 0.5,
        "Malformed non-list API input is rejected; empty or unknown-only input has no ranking.",
        size=10.8, color=MID, bold=True, valign=MSO_ANCHOR.MIDDLE)

# 7 — Exact scoring and tie
s = prs.slides.add_slide(BLANK); add_bg(s)
heading(s, "06 · Scoring", "Exact fractions preserve equal scores as ties",
        "The denominator is each condition’s list length; this is a software rule, not a probability.", 7)
card(s, 0.78, 2.14, 4.1, 3.8, fill=NAVY, line=NAVY)
pill(s, 1.06, 2.43, 1.56, "APPLICATION RULE", fill="244551", color="A7E4D7", size=8.7)
textbox(s, 1.1, 3.04, 3.4, 0.76, "N / D", size=42, color=PAPER,
        bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 1.1, 3.91, 3.4, 0.82,
        "N = unique shared features\nD = unique features in that profile",
        size=15.2, color="BBD2D7", align=PP_ALIGN.CENTER,
        valign=MSO_ANCHOR.MIDDLE)
line(s, 1.24, 5.03, 4.42, 5.03, "42616B", 1)
textbox(s, 1.12, 5.19, 3.37, 0.46,
        "Compare exactly: N₁ × D₂ vs N₂ × D₁",
        size=14.4, color="F4D88E", bold=True,
        align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
card(s, 5.35, 2.35, 3.05, 2.43, fill=MINT, line="BEDFD4")
pill(s, 5.64, 2.63, 1.42, "OBSERVED TIE", fill="CBEADF", color=TEAL, size=9)
textbox(s, 5.62, 3.17, 2.5, 0.43, "Measles", size=20, color=NAVY,
        bold=True, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 5.62, 3.67, 2.5, 0.5, "3 / 6", size=26, color=TEAL,
        bold=True, valign=MSO_ANCHOR.MIDDLE)
card(s, 9.03, 2.35, 3.05, 2.43, fill=PALE_GOLD, line="E7D7AC")
pill(s, 9.31, 2.63, 1.42, "OBSERVED TIE", fill="F6E7BD", color="8B6820", size=9)
textbox(s, 9.3, 3.17, 2.5, 0.43, "Common cold", size=20, color=NAVY,
        bold=True, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 9.3, 3.67, 2.5, 0.5, "4 / 8", size=26, color="8B6820",
        bold=True, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 8.37, 3.4, 0.55, 0.42, "=", size=28, color=TEAL,
        bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
card(s, 5.42, 5.22, 6.6, 0.72, fill=PAPER)
textbox(s, 5.66, 5.35, 6.12, 0.43,
        "3 × 8 = 4 × 6 = 24   →   retain both conditions",
        size=17, color=NAVY, bold=True, align=PP_ALIGN.CENTER,
        valign=MSO_ANCHOR.MIDDLE)
textbox(s, 5.55, 6.14, 6.36, 0.36,
        "A ranking can favor shorter lists; it has no clinical meaning.",
        size=12.1, color=CORAL, bold=True, align=PP_ALIGN.CENTER,
        valign=MSO_ANCHOR.MIDDLE)

# 8 — Executed demo
s = prs.slides.add_slide(BLANK); add_bg(s)
heading(s, "07 · Demonstration", "Observed console output: messy input + tie",
        "Executed locally with the full five-case demo; actual Windows behavior remains unverified.", 8)
card(s, 0.78, 2.1, 5.78, 3.98, fill=NAVY, line=NAVY)
pill(s, 1.04, 2.37, 1.58, "MESSY INPUT", fill="244551", color="A7E4D7", size=9)
# Output fields
for idx, (label, value, color) in enumerate([
    ("Unique recognised", "fever · headache · nasal_congestion", PAPER),
    ("Unknown", "banana", "F29A87"),
    ("Duplicate collapsed", "fever-2", "F4D88E"),
]):
    y = 2.98 + idx * 0.79
    textbox(s, 1.06, y, 1.8, 0.28, label.upper(), size=9.4,
            color="BBD2D7", bold=True, valign=MSO_ANCHOR.MIDDLE)
    textbox(s, 1.06, y + 0.27, 4.9, 0.38, value, size=13.4,
            color=color, bold=True, valign=MSO_ANCHOR.MIDDLE)
line(s, 1.06, 5.43, 6.18, 5.43, "42616B", 1)
textbox(s, 1.1, 5.56, 4.96, 0.31,
        "Top software fraction: 3 / 8  ·  Common cold",
        size=13, color=PAPER, bold=True, valign=MSO_ANCHOR.MIDDLE)
card(s, 6.98, 2.1, 5.4, 3.98, fill=PAPER)
pill(s, 7.27, 2.37, 1.35, "TIE CASE", fill=MINT, color=TEAL, size=9)
textbox(s, 7.3, 3.02, 4.75, 0.36, "TIE at 3/6:", size=18, color=TEAL,
        bold=True, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 7.3, 3.48, 4.75, 0.78, "Measles 3/6\nCommon cold 4/8", size=20,
        color=NAVY, bold=True, valign=MSO_ANCHOR.MIDDLE)
line(s, 7.3, 4.47, 12.0, 4.47, LINE, 1)
textbox(s, 7.3, 4.67, 4.78, 0.82,
        "All equal top results are retained. No condition is selected as a diagnosis.",
        size=14, color=INK, valign=MSO_ANCHOR.MIDDLE)
card(s, 1.02, 6.35, 11.25, 0.42, fill=PALE_GOLD, line="E7D7AC")
textbox(s, 1.2, 6.39, 10.9, 0.31,
        "Demo command: swipl -q -s src/symptom_matcher.pl -- --demo",
        size=11.4, color="6F571F", bold=True, font="Aptos Mono",
        valign=MSO_ANCHOR.MIDDLE)

# 9 — Test evidence
s = prs.slides.add_slide(BLANK); add_bg(s)
heading(s, "08 · Verification", "A positive test run — plus regression controls",
        "Observed in the recorded Linux environment; not evidence of Windows compatibility or clinical validity.", 9)
card(s, 0.8, 2.12, 3.34, 3.88, fill=NAVY, line=NAVY)
textbox(s, 1.07, 2.47, 2.78, 0.4, "64", size=38, color=PAPER,
        bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 1.05, 2.95, 2.84, 0.35, "test declarations", size=14,
        color="BBD2D7", align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
line(s, 1.3, 3.48, 3.63, 3.48, "42616B", 1)
textbox(s, 1.05, 3.72, 2.84, 0.5, "180", size=34, color="A7E4D7",
        bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 1.05, 4.25, 2.84, 0.35, "passing executions", size=14,
        color="BBD2D7", align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
pill(s, 1.48, 5.03, 1.96, "0 FAILURES", fill="244551", color="A7E4D7", size=10)
textbox(s, 1.08, 5.46, 2.78, 0.32, "exit status 0", size=12.5,
        color=PAPER, bold=True, align=PP_ALIGN.CENTER, valign=MSO_ANCHOR.MIDDLE)
controls = [
    ("Qualification removed", "Detected · test failed", CORAL),
    ("Duplicate dry-cough fact", "Detected · integrity tests failed", CORAL),
    ("Required suite missing", "Rejected · load_failed", GOLD),
    ("All suites empty", "Rejected · empty_suite", GOLD),
]
for i, (title, status, accent) in enumerate(controls):
    y = 2.18 + i * 0.9
    dot(s, 4.65, y + 0.14, accent, 0.16)
    textbox(s, 4.97, y, 3.1, 0.34, title, size=14.1, color=NAVY,
            bold=True, valign=MSO_ANCHOR.MIDDLE)
    textbox(s, 8.12, y, 3.9, 0.34, status, size=12.5, color=MID,
            valign=MSO_ANCHOR.MIDDLE)
    if i < 3: line(s, 4.96, y + 0.55, 12.05, y + 0.55, LINE, 0.8)
card(s, 4.63, 6.05, 7.47, 0.52, fill=PALE_GOLD, line="E7D7AC")
textbox(s, 4.84, 6.11, 7.05, 0.36,
        "SWI-Prolog 10.0.2  ·  Debian 12  ·  Linux x86_64  ·  Windows run pending",
        size=11.4, color="6F571F", bold=True, valign=MSO_ANCHOR.MIDDLE)

# 10 — Limitations, references, and pending actions
s = prs.slides.add_slide(BLANK); add_bg(s)
heading(s, "09 · Close", "What the prototype shows — and what remains",
        "Implementation evidence is not approval, clinical validation, or final submission.", 10)
add_round_text(s, 0.78, 2.12, 5.55, 1.38, "Limitations",
               "Four small profiles · incomplete vocabulary · no clinical validation · source lists do not define the ranking.",
               accent=CORAL, fill=PALE_CORAL, title_size=15.5, body_size=12)
add_round_text(s, 0.78, 3.78, 5.55, 1.47, "Pending human work",
               "Review scope · rerun on Windows · deliver oral defense · record/upload the Drive video · submit and confirm.",
               accent=GOLD, fill=PALE_GOLD, title_size=15.5, body_size=12)
card(s, 6.72, 2.12, 5.66, 3.14, fill=PAPER)
textbox(s, 7.0, 2.34, 5.1, 0.34, "SOURCE PAGES CHECKED  ·  9 NOV 2026", size=10.5,
        color=TEAL, bold=True, valign=MSO_ANCHOR.MIDDLE)
refs = [
    ("WHO · Malaria (4 Dec 2025)", "https://www.who.int/news-room/fact-sheets/detail/malaria"),
    ("WHO · Influenza (28 Feb 2025)", "https://www.who.int/news-room/fact-sheets/detail/influenza-(seasonal)"),
    ("WHO · Measles (15 Jul 2026)", "https://www.who.int/news-room/fact-sheets/detail/measles"),
    ("CDC · Common cold (19 Feb 2026)", "https://www.cdc.gov/common-cold/about/index.html"),
]
for i, (label, url) in enumerate(refs):
    y = 2.86 + i * 0.48
    dot(s, 7.02, y + 0.08, (TEAL, GOLD, CORAL, "4C85A6")[i], 0.12)
    shape = textbox(s, 7.26, y, 4.72, 0.31, label, size=12.1,
                    color=INK, valign=MSO_ANCHOR.MIDDLE)
    for para in shape.text_frame.paragraphs:
        for run in para.runs:
            run.hyperlink.address = url
card(s, 7.0, 4.83, 5.08, 0.28, fill=MINT, line=MINT)
textbox(s, 7.13, 4.84, 4.8, 0.26,
        "Full source mappings: docs/source-register.md",
        size=10.2, color=TEAL, bold=True, valign=MSO_ANCHOR.MIDDLE)
textbox(s, 0.83, 5.68, 11.4, 0.36,
        "Assignment brief: docs/Project.pdf  ·  Report: docs/final-report.md  ·  Demo: presentation/demonstration-script.md",
        size=11.2, color=MID, valign=MSO_ANCHOR.MIDDLE)
card(s, 0.82, 6.17, 11.48, 0.52, fill=NAVY, line=NAVY)
textbox(s, 1.04, 6.21, 11.0, 0.4,
        "NO DIAGNOSIS  ·  NO PROBABILITIES  ·  NO TREATMENT OR URGENCY ADVICE",
        size=13.2, color="F4D88E", bold=True, align=PP_ALIGN.CENTER,
        valign=MSO_ANCHOR.MIDDLE)

# Save. The output is a required submission deliverable, not a generated preview image.
OUT.parent.mkdir(parents=True, exist_ok=True)
prs.save(OUT)
print(f"Wrote {OUT} ({OUT.stat().st_size} bytes; {len(prs.slides)} slides)")
