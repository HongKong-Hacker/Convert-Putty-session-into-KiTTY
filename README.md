#

This is a Windows PowerShell script that export putty session into "Windows system temp folder\PuTTYSettings.reg",
search and replace the words "SimonTatham\PuTTY" text with "9bis.com\KiTTY".

Then ask for the confirmation to delete the existing "9bis.com\KiTTY", if you choose "Y", then it will delete it. If you choose "N", it will keep it and import the above exported and modified putty session into KiTTY session.
