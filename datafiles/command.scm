VIEW           100       0       0       0       0       0
Displays the picture with the current orientation.
No arguments needed.
COPY           101       0       0       0      10       9
Sends the current picture to a hard copy file.
Input the filename.
XROT           103       0       0       1       0       0
Requires one real argument in degrees, rotates molecule about the x-axis.
This command requires one numeric argument, the angle of rotation in degrees.
YROT           104       0       0       1       0       0
Requires one real argument in degrees, rotates molecule about the y-axis.
This command requires one numeric argument, the angle of rotation in degrees.
ZROT           105       0       0       1       0       0
Requires one real argument in degrees, rotates molecule about the z-axis.
This command requires one numeric argument, the angle of rotation in degrees.
ROTATE         106       0       0       3       0       0
Requires three reals, rotations in degrees about x,y,z respectivly.
This command requires three arguments, rotations in degrees about x y and z.
PLANE          108       0       0       0      31     -14
Project onto a plane.Minimum of three atoms specify the plane,eg C1,C2,C3.
This command requires at least three atoms to define the plane.
FACE           109       0       3       0       0       0
Requires three integers h,k,l to specify a face to project the picture onto.
This command requires three integers to specify the face for the projection.
ALONG          110       0       0       0      20     -14
View along a bond eg C1 C2 or an AXIS
This command requires two atom names.
AXIS           111     110       0       0      10       3
View looking along an axis.
This command requires the axis name, A B or C.
VERTICAL       112       0       0       0      20     -14
View with a bond eg C1 C2 in the vertical position - rotate in the xy plane.
This command requires two atom names eg C1 C2.
HORIZONTAL     113       0       0       0      20     -14
View with a bond eg C1 C2 horizontal - rotate in the xy plane only.
This command requires two atom names.
BISECT         114       0       0       0      30       1
View along the bisector of the angle given by C1 C2 C3, C2 is at the centre.
This command requires three atom names C1 C2 C3 - C2 is the apex atom.
CURSOR         115       0       0       0       0       0
Use the cursor keys (and Delete,End) to rotate the molecule in 5 degree steps.
No arguments needed.
ALL            116     108       0       0       0       0
This command calculates a 'best view' of the current structure'.
No arguments needed.
PHOTO          118       0       0       0       0      -4
Output a clean graphics picture so that a photo can be taken of it.
Needs to be followed by ON or OFF.
ON             119     118       0       0       0       0
Turn on the PHOTO mode.
No arguments needed.
OFF            120     118       0       0       0       0
Turn of PHOTO mode.
NO arguments needed.
MATRIX         121       0       0       0       0      -4
Header command for view matrix storage.
Follow by a sub-command.
FILE           122     121       0       0      10       9
The name of the file to be used for matrix storage/retrieval.
Input the filename.
STORE          123    -121       0       0      10       9
Store the current view matrix, together with its desriptive text.
Input a text description for the current view matrix.
RETRIEVE       124    -121       1       0       0       0
Retrieve and use a numbered view matrix.
Input the number of the matrix to be used.
LIST           125    -121       0       0       0       0
Ouput a list of the currently stored view matrices.
No arguments needed.
AXIS           126     112       0       0      10       3
Rotate the picture in the xy plane so that the axis specified is vertical.
Input the axis to define the rotation.
AXIS           127     113       0       0      10       3
Rotate the picture in the xy plane so that the axis specified is horizontal.
Input the axis to define the rotation.
STEREO         128       0       0       0       0       0
Draw the picture as two stereo pairs.
No arguments needed.
NOSTEREO       129       0       0       0       0       0
Draw the picture as normal.
No arguements needed.
DEGREE         130     128       0       1       0       0
Input the angle of rotation in degrees.
Input the angle of rotation in degrees.
LINE           200       0       0       0       1     -24
Specify the atoms/elements to be drawn in line mode
This command requires the input of atoms/elements to be drawn in line mode.
ALL            201     200       0       0       0       0
All of the atoms are drawn in line mode. This is the default.
No arguments needed
GROUP          202     200       0       0       1       5
Input the group name that is to be drawn in line format.
This command requires a group name - the group must have been pre-defined.
FRAGMENT       215     200       0       0       1       1
Alter all of the atoms joined to the specified one to line style.
Input the fragment defining atom.
BALL           203       0       0       0       1     -24
Specify the atoms/elements to be drawn in ball+stick mode 
This command requires the atoms/elements to be drawn in BALL mode.
RADII          204     203       0       1       1     -24
Specify the drawing radii eg C1 0.4 O 0.35
This command requires an atom/element name followed by its new drawing radius.
ALL            205     203       0       0       0       0
Draw all atoms in ball and stick mode.
No arguments needed.
GROUP          206     203       0       0       1       5
Input the group name and draw all of the group in ball and stick mode.
This command requires a group name which has been pre-defined (DEFGROUP).
FRAGMENT       216     203       0       0       1       1
Alter all of the atoms joined to the specified one to ball style.
Input the fragment defining atom.
FILL           207       0       0       0       0       0
Any atoms in drawn in ball+stick mode will be filled with colour if possible.
No arguments needed.
UNFILL         208       0       0       0       0       0
Draw all atoms as 'empty' circles.
No arguments needed.
ELLIPSE        209       0       0       0       1     -24
Specify the atoms/elements to be drawn as ellipses.
This command requires to names of the atoms/elements to be drawn as ellipsoids
ALL            210     209       0       0       0       0
Draw all atoms in the ellipse format.
No arguments needed.
GROUP          211     209       0       0       1       5
Draw all atoms in group no/name as ellipses.
This command requires a group name (see DEFGROUP).
FRAGMENT       217     209       0       0       1       1
Alter all of the atoms joined to the specified one to ellipse style.
Input the fragment defining atom.
TYPE           212     209       1       0       1     -24
Ellipse type number together with the atoms/elements to be affected.
This command requires a number to specify the ellipse type and the atoms.
NEGATIVE       213     209       0       1       0       0
When a negative temperature factor is encountered its value is reset to this.
This command requires a value for a negative temperature factor to be set to.
DEFAULT        214     204       0       0       0       0
This resets all the drawing radii to their default values.
No arguments needed.
KEY            224       0       0       0       0       0
Displays an atom colour key at the RHS of the screen
No arguments required.
NOKEY          225       0       0       0       0       0
Turns off the atom colour key.
No arguments needed.
PROBABILITY    226     209       0       1       0       0
Alter the ellipse scaling factor
One number needed.
COVALENT       218     204       0       0       1     -24
Set the drawing radii to their covalent values.
Input the atoms to be changed or use ALL.
IONIC          219     204       0       0       1     -24
Set the drawing radii to their ionic values.
Input the atoms to be changed or use ALL.
VANDERWAALS    220     204       0       0       1     -24
Set the drawing radii to their Van der Waals values.
Input the atoms to be changed or use ALL.
ALL            221     218       0       0       0       0
Set all of the atoms drawing radii to covalent.
No arguments needed.
ALL            222     219       0       0       0       0
Set all of the atoms drawing radii to ionic.
No arguments needed.
ALL            223     220       0       0       0       0
Set all of the atoms drawing radii to Van der Waals.
No arguments needed.
ALL            230     212       1       0       0       0
Change of the atoms to the ellipse type specified.
Input the ellipse type number.
CONNECT        300       0       0       2      20     -24
Calculates connectivity for atoms/elements specified within the given range.
Input the atoms/elements to be joined together with the min/max distance.
INTER          326     300       0       2      20       2
Generate connections between atoms of different pack numbers.
Input the atoms/elements to be connected and the range.
HBONDS         301     300       0       2      11       2
Calculates any H-bonds involving the given atoms within the given distance.
Input the max dist for a H-bond and elements to be included in the calc.
JOIN           302       0       0       0       0      -4
Join header command follow with FULL or DOTTED.
No arguments needed.
FULL           317     302       0       0       2       1
Will join the bonds specified as a solid line. 
Input the atoms to define the bonds in pairs.
DOTTED         318     302       0       0       2       1
Will join the bonds specified as a dotted line.
Input the atoms to define the bonds in pairs.
FULL           304     300       0       0       2       2
Draw the bonds specified as a solid line, applies to existing bonds eg C-O. 
Input the atoms or elements which define the bonds.
DOTTED         306     300       0       0       2       2
Draw the bonds specified as a dotted line, applies to existing bonds eg C-O. 
Input the atoms or elements which define the bonds.
RADII          303     300       0       1       1       2
Input connectivity radii for atoms/elements eg C1 0.5 or O 0.7.
Input atom/elements name followed by a conn. radius. eg C1 0.5 O 0.7.
REMOVE         307       0       0       0       2       2
Remove bond between specified atoms/elements eg C1 C3, C O, C1 O.
Input atoms to define the bond to be removed.
DISCONNECT     308       0       0       2      20     -24
Break any bonds involving the spec. ats/els outside the specified range.
Input atoms/elements and a min/max distance for an ALLOWED bond.
ALL            309     308       0       2       0       0
Break any bonds inside the specified range.
Input the min/max distance for the allowed range.
GROUP          310     308       0       0      20       5
Break any bonds that may exist between members of the two groups.
Input the names of two groups between which bonds are to be broken.
ALL            311     300       0       2       0       0
This calculates the connectivity adding in any bonds inside the range.
This command requires the min/max length of the new bonds.
DEFAULT        312     300       0       0       0       0
This calcs the connectivity for all the atoms according to default conn radii.
No arguments needed.
TAPER          313    -300       0       1       0       0
Bond tapering factor.
Input the bond tapering factor.
TOLERANCE      315    -300       0       1       0       0
Tolerance (in angstrom) used when calculating bonds.
Input the tolerance in angstrom used when calculating connectivity.
THICKNESS      316    -300       0       1       0       0
Specifies the thickness (radius) of the bonds in angstrom - initially 0.02.
Input the thickness (radius) of the bonds in angstrom - initially 0.02.
COVALENT       319     303       0       0       1     -24
Set the connectivity radii to their covalent values.
Input the atoms to be changed or use ALL.
IONIC          320     303       0       0       1     -24
Set the connectivitiy radii to their ionic values.
Input the atoms to be changed or use ALL.
VANDERWAALS    321     303       0       0       1     -24
Set the connectivity radii to their Van der Waals values.
Input the atoms to be changed or use ALL.
ALL            322     319       0       0       0       0
Set all of the atoms connectivity radii to covalent.
No arguments needed.
ALL            323     320       0       0       0       0
Set all of the atoms connectivity radii to ionic.
No arguments needed.
ALL            324     321       0       0       0       0
Set all of the atoms connectivity radii to Van der Waals.
No arguments needed.
ATOM           325     308       0       0       1       1
Remove all bonds involving the atom specified.
Input the list of atoms to be disconnected.
ADD            400       0       0       0       0      -4
Main header command for dealing with adding atoms etc using symmetry operator.
This command needs to be followed by a sub command.
ATOMS         -401     400       0       0       1       2
Specify atoms to be included in the ADD operation.
Input the name(s) of the source atom(s).
ALL            402     400       0       0       0       4
Adds a new entry to the list generated from entry no. input. Default 1.
No arguments needed
GROUP         -403     400       0       0       1       5
Generate new atoms from the group specified - they will be in this group.
Input the source group name.
OPERATORS     -404       1       0       0      30       7
Input symmetry operators to be used.eg X+1/2 Y Z-1/2.
Input the symmetry operators to be used eg X+1/2 Y Z-1/2
TRANS         -405       1       0       3       0       0
Input translational operators to be used eg 1.0 0.5 0.0.
Input translational operators to be used.
INITIAL        406     400       0       0       0       4
Apply the operators to the initial data.
No arguments needed.
MOVE           500       0       0       0       0      -4
Main header command used for moving atoms etc within the cell by symmetry.
This must be followed by a sub command.
ATOMS         -501    -500       0       0       1       2
Specify atoms to be moved.
Input atoms to be moved.
ALL            502    -500       0       0       0       4
Moves a whole entry. Default 1 - ie move all.
No arguments needed.
GROUP         -503    -500       0       0       1       5
Group nos.Names. Moves eg 1 or PHENYL to a new position.
Input name of the group to be moved.
OPERATORS     -504       1       0       0      30       7
Symmetry operator to be used.eg X+1/2 Y Z-1/2.
Input the symmetry operator to be used eg X+1/2 Y Z-1/2.
TRANS         -505       1       0       3       0       0
Translational operators to be used eg 1.0 0.5 0.0.
Input the translational operators eg 1.0 0.5 0.0.
ENCLOSURE      600       0       0       0       0      -4
This is the header command for enclosure.
No arguments needed.
GROUP         -611     600       0       0       1       5
Apply the enclosure command to a particular group, use * for ALL groups.
Input the name of the group in question, use * for ALL groups.
ATOM          -613     611       0       0       1       1
Defines the central point as an atom.
Input the name of an atom to be the central point.
POINT         -601     611       0       3       0       0
Defines the central point in fractional coordinates.
Input the central point in fractional coordinates.
ATOM          -613     600       0       0       1       1
Defines the central point as an atom.
Input the name of an atom to be the central point.
POINT         -601     600       0       3       0       0
Defines the central point in fractional coordinates.
Input the central point in fractional coordinates.
SPHERE         602     601       0       1       0       4
Defines the radius of a sphere of enclosure in Angstroms.
Input the sphere radius in angstroms.
ANORTHIC       603     601       0       6       0       4
Defines an anorthic box relative to the central point. min/max in fracts.
Please input the min/max fractional values relative to the central point.
ORTHOGONAL     604     601       0       6       0       4
Defines a box parallel to current view axes in angstroms. (min/max x 3.)
Input the min/max values in the x,y,z directions in pairs (angstroms).
SPHERE         602     613       0       1       0       4
Defines the radius of a sphere of enclosure in Angstroms.
Input the sphere radius in angstroms.
ANORTHIC       603     613       0       6       0       4
Defines an anorthic box relative to the central point. min/max in fracts.
Please input the min/max fractional values relative to the central point.
ORTHOGONAL     604     613       0       6       0       4
Defines a box parallel to current view axes in angstroms. (min/max x 3.)
Input the min/max values in the x,y,z directions in pairs (angstroms).
CUT            605     602       0       0       0       4
This only draws atoms within the defined limits. (default).
No arguments needed.
COMPLETE       606     602       0       0       0       4
Packs a complete cell and includes any residues that have an atom within it.
No arguments needed.
CENTROID       607     602       0       0       0       4
Includes any assymetric units that have their centroid in the CELL/WINDOW. 
No arguments needed.
CUT            605     603       0       0       0       4
This only draws atoms within the defined limits. (default).
No arguments needed.
COMPLETE       606     603       0       0       0       4
Packs a complete cell and includes any residues that have an atom within it.
No arguments needed.
CENTROID       607     603       0       0       0       4
Includes any assymetric units that have their centroid in the CELL/WINDOW. 
No arguments needed.
CUT            605     604       0       0       0       4
This only draws atoms within the defined limits. (default).
No arguments needed.
COMPLETE       606     604       0       0       0       4
Packs a complete cell and includes any residues that have an atom within it.
No arguments needed.
CENTROID       607     604       0       0       0       4
Includes any assymetric units that have their centroid in the CELL/WINDOW. 
No arguments needed.
INTRA          608     605       0       0       0       0
Connectivity is calculated between atoms in the same ass unit only.
No arguments needed.
INTER          609     605       0       0       0       0
Connectivitiy is calculated between all atoms once enclosure is done.
No arguments needed.
KEEP           610     605       0       0       0       0
Connectivity is moved bodily from the generating data (this is slow!).
No arguments needed.
INTRA          608     606       0       0       0       0
Connectivity is calculated between atoms in the same ass unit only.
No arguments needed.
INTER          609     606       0       0       0       0
Connectivitiy is calculated between all atoms once enclosure is done.
No arguments needed.
KEEP           610     606       0       0       0       0
Connectivity is moved bodily from the generating data (this is slow!).
No arguments needed.
INTRA          608     607       0       0       0       0
Connectivity is calculated between atoms in the same ass unit only.
No arguments needed.
INTER          609     607       0       0       0       0
Connectivitiy is calculated between all atoms once enclosure is done.
No arguments needed.
KEEP           610     607       0       0       0       0
Connectivity is moved bodily from the generating data (this is slow!).
No arguments needed.
MAXIMISE       702       0       0       0       0      -4
Relates to picture maxmisation when looking along a bond or axis.
No arguments needed.
ON             703    -702       0       0       0       0
Turn maximisation on.
No arguments needed.
OFF            704    -702       0       0       0       0
Turns picture maximisation off.
No arguments needed.
TEXT           705       0       0       0       1     -94
Input the text.
Input the text.
NUMBER         706     705       1       0       0       0
Input the number of the text to be altered.
Input the number of the text to be altered.
POSITION       707       1       0       2       0      -4
Input the x and y positions of the text x, y origin is in the bottom corner.
Input the x and y positions - values from 0 to 100.
SCALE          709       0       0       0       0      -4
Header command for scaling operations.
No arguments needed.
FIX            710     709       0       0       0       0
Turn off scale calculations.
No arguments needed.
UNFIX          711     709       0       0       0       0
Turn on scale calculations.
No arguments needed.
SET            712     709       0       1       0       0
Input the new value of the scale factor.
Input the new value of the scale factor.
FONT           713       0       1       0       0      -4
Alter the integer font size for the labels etc.
Input the new font size.
DEFAULT        714     713       0       0       0       0
Set the font size to its default value - 20 pts.
No arguments needed.
TITLE          715       0       0       0       1       9
Add a title to the picture.
Input the title.
LABEL          800       0       0       0       1      24
Specify atoms to be labelled 
no arguments needed.
ALL            801     800       0       0       0       0
Label all the atoms present.
no arguments needed.
GROUP          802     800       0       0       1       5
Label a specified group (name or no).
Input the group name or number.
MOUSE          803     800       0       0       0       0
Position labels with the mouse.
No arguments needed.
CELL           804    -800       0       0       0       0
Label the cell axes.
No arguments needed.
FRAGMENT       805     800       0       0       1       1
Label all of the atoms joined to (and including) the specified one.
Input the fragment defining atom.
FRAGMENT       806     809       0       0       1       1
Nolabel all of the atoms joined to (and including) the specified one.
Input the fragment defining atom.
NOLABEL        809       0       0       0       1     -24
Don't label specified atoms/elements
Input specific atoms/elements 
ALL            810     809       0       0       0       0
Don't label any atoms.
no arguments needed.
GROUP          811     809       0       0       1       5
Don't label a specified group name.
Input the group name.
GENERATED      812    -800       0       0       0       0
Include the pack operator number when labelling atoms.
No arguments necessary.
INITIAL        813    -800       0       0       0       0
Label the atoms according to their original labels.
No arguments needed.
CELL           815    -809       0       0       0       0
Do not label the cell
No arguments needed.
INPUT          900       0       0       0       0      -4
Input data in a specified format.
Please give the format to be used.
OUTPUT         901       0       0       0       0      -4
Output data in a specified format.
Please give the format to be used.
LIST5          902     901       0       0      10       9
Output the data in CRYSTALS List 5 format.
Please give the filename to be used.
CSSR           903     901       0       0       0      -4
Output the data in CSSR format - follow by ORTH or FRACT.
Please give the filename to be used.
ORTH           904     903       0       0      10       9
Output CSSR data as orthogonal coordinates.
Please give the filename for the CSSR output file.
FRACT          905     903       0       0      10       9
Output CSSR data as fractional coordinates.
Please give the filename for the CSSR output file.
LIST5          907     908       0       0      10       8
Input the data in CRYSTALS List 5 format, follow this with a filename.
Please input the file to be used.
CELL          -908     900       0       6       0       0
Sets the cell edges and angles a,b,c alpha,beta and gamma.
Input the six cell parameters a,b,c,alpha,beta,gamma.
CSSR           909     900       0       0      10       8
Input the data in CSSR format, follow this command with the filename.
Input the filename of an existing CSSR file.
ISSUE          913       0       0       0       1       9
Follow this command with a DOS command that will then be sent to the system.
Input the DOS command you require.
LOG            914       0       0       0      10     -94
Generate a log file (or close one with LOG CLOSE).
Input the file name.
CLOSE          915     914       0       0       0       0
Close the current log file.
No arguments needed.
PRINT          916       0       0       0      10       8
This prints the file specified.
Please input the name of the file to be printed.
EDIT           917       0       0       0       0      -4
This controls the editing facility - follow by ON or OFF.
No arguments needed.
ON             918     917       0       0       0       0
Turn on the editing facility which is used when errors are detected.
No arguments needed.
OFF            919     917       0       0       0       0
Turn off the editing facility.
No arguments needed.
PCSEND         921       0       0       0      10       8
This prints the file specified.
Please input the name of the file to be printed.
CHIME          922     901       0       0       0       0
Output a CHIME .XYZ file
Please give the filename for the CHIME output file.
OBEY          1000       0       0       0      10       8
This passes control to the command file specified.
This command needs the name of the command file to be obeyed.
RESET         1001       0       0       0       0       0
Clears the current data and sets CAMERON to its initial state.
No arguments needed.
SCREEN        1100       0       0       0       0      -4
This specifies the screen type.
Please input a screen type.
VGA           1101    1100       0       0       0       0
This sets the output device to VGA (used for PC)
No arguments needed
SIGMA         1102    1100       0       0       0       0
This sets the output device to SIGMA terminal (VAX)
No arguments needed
TEKTRONIC     1104    1100       1       0       0       0
Tektronic black and white emulation.
No arguments needed.
HARDCOPY      1111       0       0       0       0      -4
This specifies the output device for hardcopy.
Must be followed by a sub-command.
POSTSCRIPT    1105    1111       0       0       0       0
This sends the output to a POSTSCRIPT file.
No arguments needed.
ENCAPPOST     1106    1111       0       0       0       0
This generates output in Encapsulated Postscript format
No arguments needed.
EGA           1107    1100       0       0       0       0
Send output to an EGA screen.
No arguments needed.
CPOST         1108    1111       0       0       0       0
This sends the output to a colour POSTSCRIPT file.
No arguments needed.
CENCAP        1109    1111       0       0       0       0
This sends the output to an encapsulated colour POSTSCRIPT file.
No arguments needed.
SYMMETRY      1200       0       0       0       0      -4
Header command for the input of symmetry operators etc.
No arguments needed.
CENTRE        1203    1205       0       0       1     -74
Make the structure centric, follow by the centring letter or VECTORS.
Input the centering letter, I/P/A/B/C/F/R or VECTORS.
NOCENTRE      1204    1205       0       0       1     -74
Make the structure non centric, follow by the centring letter or VECTORS.
Input the centering letter, I/P/A/B/C/F/R or VECTORS.
OPERATORS    -1205    1200       0       0       3       7
These allow manual input of symmetry operators.
Please input the symmetry operators in groups of three eg X Y -Z
VECTORS       1207    1203       0       0       3      -7
This allows the input of centering vectors eg 1/2 1/2 1/2.
Please input the centering vectors in groups of 3.
VECTORS       1207    1204       0       0       3      -7
This allows the input of centering vectors eg 1/2 1/2 1/2.
Please input the centering vectors in groups of 3.
SPACEGROUP    1206       0       0       0       1       9
This command allows the input of the spacegroup. eg P 21 21 21
This command requires the input of the spacegroup eg P 21 21 21.
SETUNIT       1209       0       0       0       0       0
This command will make the assymetric unit the atoms that are on the screen.
No arguments are needed.
USE           1210    1200      -1       0       0      -4
This command specifies the numbers of the operators to be used for packing.
Input the numbers of the relevant symmetry operators.
ALL           1211    1210       0       0       0       0
Use all of the operators in packing.
No arguments needed.
NOUSE         1212    1200      -1       0       0      -4
This command needs the numbers of the operators to be omitted from packing.
Input the numbers of the operators to be omitted.
ALL           1213    1212       0       0       0       0
Do not use any of the symmetry operators in packing.
No arguments needed.
ENANTIO       1214       0       0       0       0       0
Change the enantiomer of the initial coordinates.
No arguments needed
SPECIAL       1215       0       0       0       0      -4
Change the special position calculation on or off.
Sub command needed - ON or OFF.
ON            1216    1215       0       0       0       0
Turn special position calculation on.
No arguments needed.
OFF           1217    1215       0       0       0       0
Turn special position calculation off.
No arguments needed.
COLOUR        1300       0       0       0       2     264
Main header command for control of colour.Input atoms or sub command.
Please input atom/element name and colour or sub command 
CELL          1301       1       0       0      10       6
This requires the colour of the cell.
Input the colour of the cell.
LABCOLOUR     1302       1       0       0      10       6
Alters label colour to eg RED.
Please input the label colour.
BONDS         1303       1       0       0       3   -2264
Alters the colours of bonds. eg C O yellow, C1 C3 blue, ALL.
Input two bond definers and a colour eg C O yellow or ALL.
ALL           1304    1303       0       0      10       6
Alters the colour of all bonds. Input the bond colour 
Please input the bond colour number.
TEXT          1305       1       0       0      10       6
Alters colour of text.
Input the colour number.
GROUP         1306    1303       0       0       2      56
Input the group name and the new intra-group bond colour.
Input a group name and a bond colour.
GROUP         1307    1300       0       0       2      56
Alter the colour of a group.
Please input the group name and its new colour 
NORMAL        1308    1300       0       0       0       0
Set the colour selection to normal.
No arguments needed.
GSCALE        1309    1300       0       0       0       0
Set the colour selection to greyscale.
No arguments needed.
FRAGMENT      1312    1300       0       0       2      16 
Alter the colour of a fragment eg N1 BLUE colours all joined to N1, blue.
Input the fragment defining atom and the new colour.
DEFAULT       1313    1300       0       0       0       0
Reset the atom colours to their original values.
No arguments needed.
BACKGROUND    1314    1300       0       0      10       6
Set the background colour.
Input the new background colour.
MENUTEXT      1315    1300       0       0      10       6
Set the menu text colour.
Input the new menu text colour colour.
BUTTON        1316    1300       0       0      10       6
Set the menu button colour.
Input the new button colour.
ALL           1317    1300       0       0      10       6
Set the colour for all atoms.
Input the new atom colour.
INCLUDE       1400       0       0       0       1      24
Include atoms/elements in the picture. 
Please input atoms/elements or a sub command 
ALL           1401   -1400       0       0       0       0
Include all the atoms.
no arguments needed.
GROUP         1402   -1400       0       0       1       5
Include all the members of group name ..
Please input a group name
CELL          1403   -1400       0       0       0       0
Include the cell in the drawing.
no arguments needed.
DUMMY         1404   -1400       0       0      10       9
Create a "dummy atom" at the centre of a given group. Input the atoms name.
This command requires the name of the atom to be created.
EXCLUDE       1405       0       0       0       1      24
Exclude the following atoms from the picture
Please input atoms/elements
ALL           1406   -1405       0       0       0       0
Exclude all the atoms.
no arguments needed.
GROUP         1407   -1405       0       0       1       5
Exclude all the members of group name ..
Please input a group name
CELL          1408   -1405       0       0       0       0
Exclude the cell from the drawing.
no arguments needed.
COORDS        1409    1404       0       3       0       0
This specifies the coordinates of the atom to be added as a dummy atom.
Input the fractional coordinates of the dummy atom.
CENTROID      1410    1404       0       0       1      24
This command places the dummy atom at the centroid of the group listed.
Input a list of atoms/elements to define the group.
ALL           1411    1410       0       0       0       0
Calculates the centroid of all of the atoms.
No arguments needed.
MASK          1412       0       0       0       1      24
Mask the following atoms from the picture
Please input atoms/elements
ALL           1413   -1412       0       0       0       0
Mask all the atoms.
no arguments needed.
GROUP         1414   -1412       0       0       1       5
Mask all the members of group name ..
Please input a group name
UNMASK        1415       0       0       0       1      24
Exclude the following atoms from the picture
Please input atoms/elements
ALL           1416   -1415       0       0       0       0
Exclude all the atoms.
no arguments needed.
GROUP         1417   -1415       0       0       1       5
Exclude all the members of group name ..
Please input a group name
SWITCH        1418       0       0       0       0       0
Makes all unmasked and excluded atoms visible and excludes all included atoms.
No arguments needed.
FRAGMENT      1419   -1405       0       0       1      14
Excludes a fragment identified by a single atom.
Input the atom to define the fragment.
FRAGMENT      1419   -1400       0       0       1      14
Includes a fragment identifies by a single atom.
Input the atom to define a fragment.
AREA          1420    1400       0       0       0       0
Includes the atoms defined by a polygonal area.
No arguments needed.
AREA          1421    1405       0       0       0       0
Excludes the atoms defined by a polygonal area.
No arguments needed.
SELECT        1422       0       0       0       0       0
Selects a polygonal area.
No arguments needed.
DISTANCES     1500       0       0       0       1      24
Calculate distances between atoms/elements. 
no arguments needed.
ALL           1501    1500       0       0       0       0
Includes all the atoms in the distance calculations.
No arguments needed.
RANGE         1502       1       0       2       0       0
Input the min/max distance to be computed in angstrom.
Please input the min/max distances in angstrom.
FROM          1503       1       0       0       1      24
Starting atoms for the distance calculations.
Input the names of the atoms to be used as roots.
TO            1504       1       0       0       1      24
Finishing atoms for the distance calculations.
Input the names of the atoms to be used as roots.
ANGLES        1600       0       0       0       3       1
Calculate angles between the atoms specified. at1 at2 at3. at2 is the apex.
Input atoms for the angle calculations in threes.
PACK          1700       0       0       0       0       4
Main header command for packing.
No arguments needed.
CELL          1701    1700       0       0       0       4
This packs a unit cell using all the symetry operators.
No arguments needed.
WINDOW       -1702    1700       0       6       0       0
Only draw atoms in the box defined by min/max on A B C respectively.
Input min/max values for A B C in pairs eg -1.0 1.0 -1.0 1.0 -0.5 0.5.
CUT           1703    1701       0       0       0       4
This only draws atoms within the defined limits. (default).
No arguments needed.
COMPLETE      1704    1701       0       0       0       4
Packs a complete cell and includes any residues that have an atom within it.
No arguments needed.
CENTROID      1705    1701       0       0       0       4
Includes any assymetric units that have their centroid in the CELL/WINDOW. 
No arguments needed.
CUT           1703    1702       0       0       0       4
This only draws atoms within the defined limits. (default).
No arguments needed.
COMPLETE      1704    1702       0       0       0       4
Packs a complete cell and includes any residues that have an atom within it.
No arguments needed.
CENTROID      1705    1702       0       0       0       4
Includes any assymetric units that have their centroid in the CELL/WINDOW. 
No arguments needed.
UNPACK        1706       0       0       0       0       0
Draw only the data initially input (and that created by ADD).
No arguments needed.
INTRA         1707    1703       0       0       0       0
Connectivity is calculated within ass units only during packing.
No arguments needed.
INTER         1708    1703       0       0       0       0
Connecitivty is calculated for all the atoms as a whole once pack is done.
No arguments needed.
KEEP          1709    1703       0       0       0       0      
Generates the connectivity from that of the assymetric unit (this is slow).
No arguments needed.
INTRA         1707    1704       0       0       0       0
Connectivity is calculated within ass units only during packing.
No arguments needed.
INTER         1708    1704       0       0       0       0
Connecitivty is calculated for all the atoms as a whole once pack is done.
No arguments needed.
KEEP          1709    1704       0       0       0       0      
Generates the connectivity from that of the assymetric unit (this is slow).
No arguments needed.
INTRA         1707    1705       0       0       0       0
Connectivity is calculated within ass units only during packing.
No arguments needed.
INTER         1708    1705       0       0       0       0
Connecitivty is calculated for all the atoms as a whole once pack is done.
No arguments needed.
KEEP          1709    1705       0       0       0       0      
Generates the connectivity from that of the assymetric unit (this is slow).
No arguments needed.
GROUP        -1710    1700       0       0       1       5
Specify groups to be used during the PACK operation - * specifies all groups.
Input the name of the groups to be packed - * specifies all groups.
CELL          1701    1710       0       0       0       4
This packs a unit cell using all the symmetry operators.
No arguments needed.
WINDOW       -1702    1710       0       6       0       0
Only draw atoms in the box defined by min/max on A B C respectively.
Input min/max values for A B C in pairs eg -1.0 1.0 -1.0 1.0 -0.5 0.5.
MENUS         1800       0       0       0       0      -4
Controls the method of command input.
No arguments needed.
ON            1801   -1800       0       0       0       0
Control is passed to menus.
No arguments needed.
OFF           1802   -1800       0       0       0       0
Control is passed to the keyboard
No arguments needed.
END           1900       0       0       0       0       0
Ends CAMERON.
No arguments needed.
INFO          2000       0       0       0       1     -14
Allows output of data - click on atoms to get the atom names.
Please input a sub command or click on atoms with the mouse.
CELL          2001    2000       0       0       0       0
This will output the cell parameters.
No arguments needed..
ATOMS         2002    2000       0       0       0       0
This will list the atoms present in the structure.
No arguments needed.
COLOUR        2003    2000       0       0       0       0
This will list the colour table for the current device.
No arguments needed.
SYMMETRY      2004    2000       0       0       0       0
This lists the symmetry operators being used.
No arguments needed.
GROUPS        2005    2000       0       0       0       0
This lists the contents of the defined groups.
No arguments needed.
PACKNUMBERS   2006    2000      -1       0       0       0
Information on the labelling of packed atoms.
Input a list of the pack numbers needed.
DEFGROUP     -2100       0       0       0      10       9
This allows the definition of groups of atoms, followed by the new groupname.
Please input the group name.
ATOMS         2101       1       0       0       1       2
This is followed by the atoms to be included in the new group.
Please input atoms.
GROUP         2102       1       0       0       1       5
Input the names of previously defined groups to be included in this new group.
Input the names of one or more sub groups for this group.
DELETE        2103       1       0       0       1      24
Remove atoms/elements from the group mentioned previously.
Please input the atoms/elements to remove from the group.
ALL           2104    2103       0       0       0       0
Remove all of the atoms in the group - ie delete the group.
No arguments needed.
FRAGMENT      2105   -2100       0       0       1       1
Define a group by entering a single atom to define a fragment.
Input the atom name to define the fragment and hence the group.
TORSION       2200       0       0       0       4       1
Calculate torsion angles between the bonds at1 at2 and at3 at4.
Input atoms for torsion calculations in sets of four.
RENAME        2300       0       0       0       2      29
Alter the name of an atom or element. Syntax atold atnew or elold elnew.
Input the old and new atoms/element names in pairs.
RETYPE        2301       0       0       0      10       9
Change the element type to the specified element , follow by ATOMS.
Input the new element name
ATOMS         2302    2301       0       0       1       1
Alters the element types of the following atoms.
Input the atom names of those atoms that are to be retyped.
DEFMENU       2400       0       0       0       0       0
Set or change menu buttons and text.
Followed by button.cmn source, be careful.
#HEADERS         0       0       0       0       0       0


11   5
VIEW             1
100
STYLE            1
200
BONDS            1
300
INPUT            4
900
1000
1100
1800
INCLUDE          2
1400
2300
SYMMETRY         5
400
500
600
1700
1200
LABELS           1
800
COLOUR           1
1300
DISTANCES        3
1500
1600
2200
MISC.            3
2000
2100
700
END              1
1900
#CHARACTER
9
ATOMS
ATOM/ELEMENT
AXIS 
SUBCOMMAND
GROUPNAME
COLOUR
OPERATORS
FILENAME
TEXT
