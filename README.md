Copy-Verify
===========

Simple ruby project to compare two directories and show the files missing from each. Will also randomly check some of the files with an MD5 comparison. Note that there is no gaurentee that it will not repeat MD5s on the same files.

Example: 
ruby copy-verify.rb /First/Folder/Location /Second/Folder/Location 20 true
this will compare the two locations and perform MD5 on 20 random files (including hidden dot files).
