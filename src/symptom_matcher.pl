/*
   Application entry point.

   From the repository root:
     swipl -q -s src/symptom_matcher.pl --
     swipl -q -s src/symptom_matcher.pl -- --demo
*/

:- use_module(knowledge_base).
:- use_module(inference).
:- use_module(interface).

:- initialization(symptom_console:run, main).
