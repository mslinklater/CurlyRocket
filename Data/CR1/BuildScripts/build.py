#!/usr/bin/env python

import os
import subprocess
import shutil

kSourceFolder = '../Src'
#kIntermediateFolder = '../Intermediate_Python'
kDestFolder = '../Assets'

kTexturePackerBin = '../../../bin/TexLifter'
kLuaBin = '../../../bin/luac_ios'
kTextureToolBin = '../../../bin.texturetool'
kAFConvertBin = 'afconvert'

kAudioPath = '/Audio'
kImagesPath = '/Images'
kResourcesPath = '/Resources'
kLuaPath = '/Lua'
kLuaDebugPath = '/LuaDebug'
kTexturesPath = '/Textures'

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
	except OSError as error:
		pass
	return (fileList, fileSet)

#-----------------------------------------------------------

def BuildOutputDirectories():
	if not os.path.exists( kDestFolder + kAudioPath ):	# audio
		os.makedirs( kDestFolder + kAudioPath )
		
	if not os.path.exists( kDestFolder + kImagesPath ):	# images
		os.makedirs( kDestFolder + kImagesPath )

	if not os.path.exists( kDestFolder + kResourcesPath ):	# resources
		os.makedirs( kDestFolder + kResourcesPath )

	if not os.path.exists( kDestFolder + kResourcesPath ):	# resources
		os.makedirs( kDestFolder + kResourcesPath )

#-----------------------------------------------------------

def ProcessAudio():
	srcAudioList, srcAudioSet = GetFilesAtPath( kSourceFolder + kAudioPath, split='.' )		
	destAudioList, destAudioSet = GetFilesAtPath( kDestFolder + kAudioPath, split='.' )

	filesToRemoveFromDest = destAudioSet - srcAudioSet	# remove set
	if len(filesToRemoveFromDest):
		for filename in filesToRemoveFromDest:
			os.remove( kDestFolder + kAudioPath + '/' + filename + '.' + 'm4a' )

	for filename in srcAudioList:
		srcTimestamp = os.path.getmtime( kSourceFolder + kAudioPath + '/' + filename[0] + '.' + filename[1])
		process = False
		if not os.path.exists( kDestFolder + kAudioPath + '/' + filename[0] + '.m4a' ):
			process = True
		else:
			destTimestamp = os.path.getmtime( kDestFolder + kAudioPath + '/' + filename[0] + '.m4a' )
			if destTimestamp < srcTimestamp:
				process = True
		if process:
			input = kSourceFolder + kAudioPath + '/' + filename[0] + '.' + filename[1]
			output = kDestFolder + kAudioPath + '/' + filename[0] + '.' + 'm4a'
			print("Converting " + input)
			subprocess.call( [kAFConvertBin, input, output, '-f', "m4af", '-d' ,"aac"] )

#-----------------------------------------------------------

def ProcessImages():
	srcImagesList, srcImagesSet = GetFilesAtPath( kSourceFolder + kImagesPath )		
	destImagesList, destImagesSet = GetFilesAtPath( kDestFolder + kImagesPath )

	filesToRemoveFromDest = destImagesSet - srcImagesSet	# remove set
	if len(filesToRemoveFromDest):
		for filename in filesToRemoveFromDest:
			os.remove( kDestFolder + kImagesPath + '/' + filename )

	for filename in srcImagesList:
		srcFilename = kSourceFolder + kImagesPath + '/' + filename
		destFilename = kDestFolder + kImagesPath + '/' + filename
		srcTimestamp = os.path.getmtime( srcFilename )
		process = False
		if not os.path.exists( destFilename ):
			process = True
		else:
			destTimestamp = os.path.getmtime( destFilename )
			if destTimestamp < srcTimestamp:
				process = True
		if process:
			print("Copying " + srcFilename)
			shutil.copy( srcFilename, destFilename )

#-----------------------------------------------------------

def CompileLuaDirectory( srcPath, destPath, debug ):
	if not os.path.exists( destPath ):
		os.makedirs( destPath )

	try:
		dirContents = os.listdir( srcPath )
	except OSError as error:
		print("No Lua Src files found")
		return
	
	destContents = os.listdir( destPath )
	srcSet = set()
	destSet = set()
	for file in dirContents:
		if os.path.isfile( file ):
			srcSet.add( file )
	for file in destContents:
		if os.path.isfile( file ):
			destSet.add( file )
	filesToRemoveFromDest = destSet - srcSet
	if len(filesToRemoveFromDest):
		for filename in filesToRemoveFromDest:
			os.remove( destPath + '/' + filename )

	for entry in dirContents:
		if os.path.isdir( srcPath + '/' + entry ):
			if entry.count('.') == 0:
				CompileLuaDirectory( srcPath + '/' + entry, destPath + '/' + entry, debug )		#recurse
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
					print("Compiling " + srcFilename)
					if debug:
						subprocess.call( [ kLuaBin, '-o', destFilename, srcFilename] )
					else:
						subprocess.call( [ kLuaBin, '-s', '-o', destFilename, srcFilename] )
	return

def ProcessLua():
	CompileLuaDirectory( kSourceFolder + kLuaPath, kDestFolder + kLuaPath, False )
	CompileLuaDirectory( kSourceFolder + kLuaPath, kDestFolder + kLuaDebugPath, True )
	return

#-----------------------------------------------------------

def ProcessResources():
	srcResourcesList, srcResourcesSet = GetFilesAtPath( kSourceFolder + kResourcesPath )		
	destResourcesList, destResourcesSet = GetFilesAtPath( kDestFolder + kResourcesPath )
	
	filesToRemoveFromDest = destResourcesSet - srcResourcesSet	# remove set
	if len(filesToRemoveFromDest):
		for filename in filesToRemoveFromDest:
			os.remove( kDestFolder + kResourcesPath + '/' + filename )
	
	for filename in srcResourcesList:
		srcFilename = kSourceFolder + kResourcesPath + '/' + filename
		destFilename = kDestFolder + kResourcesPath + '/' + filename
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
				print("Copying " + srcFilename)
				shutil.copy( srcFilename, destFilename )

#-----------------------------------------------------------

def ProcessTextures():
	subprocess.call(['../../../bin/TexLifter', 'texlifter.xml', '-v'])

#-----------------------------------------------------------

print("Buliding output directories")
BuildOutputDirectories()
print("Processing Audio")
ProcessAudio()
print("ProcessingImages")
ProcessImages()
print("Processing Lua")
ProcessLua()
print("Processing Resources")
ProcessResources()
print("Packing Textures")
ProcessTextures()



