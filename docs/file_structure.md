# File Structure of Quingo XText Compiler Source

## Folders
```
docs                    -- Documents
org.qdt.quingo.parent   -- Eclipse project of the compiler's source
|- org.qdt.quingo       -- The language core
|- org.qdt.quingo.ide   -- Files related to LSP server
|- org.qdt.quingo.tests	-- Test files for Quingo syntax
|- org.qdt.quingo.ui    -- Files related to Eclipse plugin
|- pom.xml              -- Maven project file for building the LSP server
quingo.source           -- Eclipse project of example Quingo files
```
## Important source files
Most important source files are located in folder org.qdt.quingo.parent/org.qdt.quingo/src/org/qdt/quingo. These files include:

- Quingo.xtext. The syntax file, which is the most important file in the project. It defines the structure of the AST. Therefore, the parser is built based on this file, which is generated in the org.qdt.quingo.parent/org.qdt.quingo/src-gen folder.

- generator/QuingoGenerator.xtend. The file describing the generator. Its input is the program AST, and the output is an eQASM file.

- generator/QuingoGeneratorUtiles.xtend. This file defines some data structures that are used in the generator.

- generator/Main.java. The entry point of the .jar compiler.

- typing/Quingo.xsemantics. The Xsemantics file that defines the typing system.

- validation/QuingoValidator. The validator that validate a source program.

- scouping/QuingoScopeProvider. The scope provider, which defines the scope of AST nodes, such as the Variable.

Other important files include:
- org.qdt.quingo.parent/org.qdt.quingo.ide/src/org/qdt/quingo/ide/ServerLauncher.xtend. The top file defining the LSP server.

- org.qdt.quingo.parent/org.qdt.quingo.tests/src/org/qdt/quingo/tests/QuingoParsingTest.xtend. The syntax test file.