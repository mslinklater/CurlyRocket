#!/usr/bin/env python

import os
import subprocess
import shutil
import argparse
import time
import sys

kSourceFolder = '/Src'
#kIntermediateFolder = '../Intermediate_Python'
kDestFolder = '/Assets'

kTexturePackerBin = '../../bin/TexLifter'
kLuaBin = '../../bin/luac_ios'
kTextureToolBin = '../../bin.texturetool'
kAFConvertBin = 'afconvert'

kAudioPath = '/Audio'
kImagesPath = '/Images'
kResourcesPath = '/Resources'
kLuaPath = '/Lua'
#kLuaDebugPath = '/LuaDebug'
kTexturesPath = '/Textures'
kFontsPath = '/Fonts'

gProjectName = ''
gMaster = False
gVerbose = False

#-----------------------------------------------------------

def GetFilesAtPath( path, split=None ):
	fileList = list()
	fileSet = set()
	try:
		for filename in os.listdir( path ):
			if not filename.startswith('.'):		# remove unwanted filenames
				if split is not None:
					filename = filename.split('.')
					fileList.append(filename)
					fileSet.add(filename[0])
				else:
					fileList.append(filename)
					fileSet.add(filename)

	except OSError as error:
		pass
	return (fileList, fileSet)

#-----------------------------------------------------------

def BuildOutputDirectories():
	audioPath = "../" + gProjectName + kDestFolder + kAudioPath
	if not os.path.exists( audioPath ):
		if gVerbose:
			print( "Creating directory: " + audioPath )
		os.makedirs( audioPath )

	imagesPath = "../" + gProjectName + kDestFolder + kImagesPath
	if not os.path.exists( imagesPath ):
		if gVerbose:
			print( "Creating directory: " + imagesPath )
		os.makedirs( imagesPath )

	resourcesPath = "../" + gProjectName + kDestFolder + kResourcesPath
	if not os.path.exists( resourcesPath ):
		if gVerbose:
			print( "Creating directory: " + resourcesPath )
		os.makedirs( resourcesPath )

	luaPath = "../" + gProjectName + kDestFolder + kLuaPath
	if not os.path.exists( luaPath ):
		if gVerbose:
			print( "Creating directory: " + luaPath )
		os.makedirs( luaPath )

	fontsPath = "../" + gProjectName + kDestFolder + kFontsPath
	if not os.path.exists( fontsPath ):
		if gVerbose:
			print( "Creating directory: " + fontsPath )
		os.makedirs( fontsPath )

	texturesPath = "../" + gProjectName + kDestFolder + kTexturesPath
	if not os.path.exists( texturesPath ):
		if gVerbose:
			print( "Creating directory: " + texturesPath )
		os.makedirs( texturesPath )

#-----------------------------------------------------------

def ProcessAudio():
	audioSource = "../" + gProjectName + kSourceFolder + kAudioPath
	audioDest = "../" + gProjectName + kDestFolder + kAudioPath

	srcAudioList, srcAudioSet = GetFilesAtPath( audioSource, split='.' )
	destAudioList, destAudioSet = GetFilesAtPath( audioDest, split='.' )

	filesToRemoveFromDest = destAudioSet - srcAudioSet	# remove set
	if len(filesToRemoveFromDest):
		for filename in filesToRemoveFromDest:
			if gVerbose:
				print("Removing: " + audioDest + '/' + filename + '.' + 'm4a' )
			os.remove( audioDest + '/' + filename + '.' + 'm4a' )

	for filename in srcAudioList:
		srcTimestamp = os.path.getmtime( audioSource + '/' + filename[0] + '.' + filename[1])
		process = False
		if not os.path.exists( audioDest + '/' + filename[0] + '.m4a' ):
			if gVerbose:
				print("Destination: " + audioDest + '/' + filename[0] + '.m4a' + "Doesn't exist")
			process = True
		else:
			destTimestamp = os.path.getmtime( audioDest + '/' + filename[0] + '.m4a' )
			if destTimestamp < srcTimestamp:
				if gVerbose:
					print("Destination: " + audioDest + '/' + filename[0] + '.m4a' + "Is out of date")
				process = True
		if process:
			input = audioSource + '/' + filename[0] + '.' + filename[1]
			output = audioDest + '/' + filename[0] + '.' + 'm4a'
			print( "Converting " + input + " as " + output )
			subprocess.call( [kAFConvertBin, input, output, '-f', "m4af", '-d' ,"aac"] )

#-----------------------------------------------------------

def ProcessImagesInFolders( src, dest ):
	if not os.path.exists( dest ):
		if gVerbose:
			print( "Creating directory: " + dest )
		os.makedirs( dest )

	srcImagesList, srcImagesSet = GetFilesAtPath( src )
	destImagesList, destImagesSet = GetFilesAtPath( dest )

	filesToRemoveFromDest = destImagesSet - srcImagesSet	# remove set
	if len(filesToRemoveFromDest):
		for filename in filesToRemoveFromDest:
			delName = dest + '/' + filename
			if gVerbose:
				print("Removing: " + delName )
			if os.path.isdir( delName ):
				shutil.rmtree( delName )
			else:
				os.remove( delName )

	for filename in srcImagesList:
		srcFilename = src + '/' + filename
		destFilename = dest + '/' + filename
		if os.path.isdir( srcFilename ):
			if filename.count('.') == 0:
				ProcessImagesInFolders( srcFilename, destFilename ) # recurse into subdirectory
		else:
			srcTimestamp = os.path.getmtime( srcFilename )
			process = False
			if not os.path.exists( destFilename ):
				if gVerbose:
					print( "Destination: " + destFilename + " does not exist" )
				process = True
			else:
				destTimestamp = os.path.getmtime( destFilename )
				if destTimestamp < srcTimestamp:
					if gVerbose:
						print( "Destination: " + destFilename + " is out of date" )
					process = True
			if process:
				if gVerbose:
					print( "Copying " + srcFilename )
				shutil.copy( srcFilename, destFilename )

def ProcessImages():
	imageSrc = "../" + gProjectName + kSourceFolder + kImagesPath
	imageDest = "../" + gProjectName + kDestFolder + kImagesPath
	ProcessImagesInFolders( imageSrc, imageDest )


#-----------------------------------------------------------

def CompileLuaDirectory( srcPath, destPath ):
	try:
		dirContents = os.listdir( srcPath )
	except OSError as error:
		print("No Lua Src files found")
		return

	if not os.path.exists( destPath ):
		if gVerbose:
			print( "Creating directory: " + destPath )
		os.makedirs( destPath )

	destContents = os.listdir( destPath )
	srcSet = set()
	destSet = set()
	for file in dirContents:
		if os.path.isfile( srcPath + "/" + file ):
			srcSet.add( file )
	for file in destContents:
		if os.path.isfile( destPath + "/" + file ):
			destSet.add( file )
	filesToRemoveFromDest = destSet - srcSet
	if len(filesToRemoveFromDest):
		for filename in filesToRemoveFromDest:
			if gVerbose:
				print( "Removing: " + destPath + '/' + filename )
			os.remove( destPath + '/' + filename )

	for entry in dirContents:
		if os.path.isdir( srcPath + '/' + entry ):
			if entry.count('.') == 0:
				CompileLuaDirectory( srcPath + '/' + entry, destPath + '/' + entry ) # recurse into subdirectory
		else:
			if entry.endswith( '.lua' ):
				srcFilename = srcPath + '/' + entry
				destFilename = destPath + '/' + entry
				process = True
				if os.path.exists( destFilename ):
					srcTimestamp = os.path.getmtime( srcFilename )
					destTimestamp = os.path.getmtime( destFilename )
					if srcTimestamp < destTimestamp:
						process = False
				if process:	
					if gMaster:
						print("Compiling & stripping" + srcFilename)
						subprocess.call( [ kLuaBin, '-s', '-o', destFilename, srcFilename] )
					else:
						print("Compiling " + srcFilename)
						subprocess.call( [ kLuaBin, '-o', destFilename, srcFilename] )
	return

def ProcessLua():
	CompileLuaDirectory( "../" + gProjectName + kSourceFolder + kLuaPath, "../" + gProjectName + kDestFolder + kLuaPath )
	return

#-----------------------------------------------------------

def ProcessFonts():
	srcPath = "../" + gProjectName + kSourceFolder + kFontsPath
	destPath = "../" + gProjectName + kDestFolder + kFontsPath
	srcResourcesList, srcResourcesSet = GetFilesAtPath( srcPath )
	destResourcesList, destResourcesSet = GetFilesAtPath( destPath )

	filesToRemoveFromDest = destResourcesSet - srcResourcesSet	# remove set
	if len(filesToRemoveFromDest):
		for filename in filesToRemoveFromDest:
			if gVerbose:
				print("Removing: " + destPath + '/' + filename)
			os.remove( destPath + '/' + filename )

	for filename in srcResourcesList:
		srcFilename = srcPath + '/' + filename
		destFilename = destPath + '/' + filename
		srcTimestamp = os.path.getmtime( srcFilename )
		process = False
		if not os.path.exists( destFilename ):
			process = True
		else:
			destTimestamp = os.path.getmtime( destFilename )
			if destTimestamp < srcTimestamp:
				process = True
		if process:
			if os.path.isfile(srcFilename):
				if gVerbose:
					print("Copying " + srcFilename)
				shutil.copy( srcFilename, destFilename )
#-----------------------------------------------------------

def ProcessResources():
	srcPath = "../" + gProjectName + kSourceFolder + kResourcesPath
	destPath = "../" + gProjectName + kDestFolder + kResourcesPath
	srcResourcesList, srcResourcesSet = GetFilesAtPath( srcPath )
	destResourcesList, destResourcesSet = GetFilesAtPath( destPath )
	
	filesToRemoveFromDest = destResourcesSet - srcResourcesSet	# remove set
	if len(filesToRemoveFromDest):
		for filename in filesToRemoveFromDest:
			if gVerbose:
				print("Removing: " + destPath + '/' + filename)
			os.remove( destPath + '/' + filename )
	
	for filename in srcResourcesList:
		srcFilename = srcPath + '/' + filename
		destFilename = destPath + '/' + filename
		srcTimestamp = os.path.getmtime( srcFilename )
		process = False
		if not os.path.exists( destFilename ):
			process = True
		else:
			destTimestamp = os.path.getmtime( destFilename )
			if destTimestamp < srcTimestamp:
				process = True
		if process:
			if os.path.isfile(srcFilename):
				if gVerbose:
					print("Copying " + srcFilename)
				shutil.copy( srcFilename, destFilename )

#-----------------------------------------------------------

def ProcessTextures():
	pass
#	subprocess.call(['../../bin/TexLifter', 'texlifter.xml', '-v'])

#-----------------------------------------------------------

def ParseCommandLine():
	parser = argparse.ArgumentParser()
	parser.add_argument("project", help="The name of the project subdirectory to build")
	parser.add_argument("-v", "--verbose", help="Verbose output - useful for debugging", action="store_true")
	parser.add_argument("-d", "--daemon", help="Daemon mode - keep building until stopped", action="store_true")
	parser.add_argument("-m", "--master", help="Master build mode. Use for master builds to enable master-only options like debug symbol removal and encryption", action="store_true")
	return parser.parse_args()

#-----------------------------------------------------------

def ProcessMain():
	if gVerbose:
		print("Building output directories")

	BuildOutputDirectories()

	if gVerbose:
		print("Processing Audio")

	ProcessAudio()

	if gVerbose:
		print("Processing Images")

	ProcessImages()

	if gVerbose:
		print("Processing Lua")

	ProcessLua()

	if gVerbose:
		print("Processing Fonts")

	ProcessFonts()

	if gVerbose:
		print("Processing Resources")

	ProcessResources()

	if gVerbose:
		print("Packing Textures")

	ProcessTextures()

#-----------------------------------------------------------

if __name__ == "__main__":

	args = ParseCommandLine()

	gProjectName = args.project
	gVerbose = args.verbose
	gMaster = args.master
	gDaemon = args.daemon

	ProcessMain()

	while gDaemon:
		time.sleep(2)
		ProcessMain()


