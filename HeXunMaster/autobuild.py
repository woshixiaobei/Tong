#!/usr/bin/env python
# -*- coding:utf-8 -*-

#./autobuild.py
import json
from subprocess import Popen, PIPE
from optparse import OptionParser
import subprocess
import requests
import plistlib
import time
import types

#configuration for iOS build setting
CODE_SIGN_IDENTITY = "iPhone Distribution: Hexun Information Technology Co.,Ltd. (X4P5KW4G5C)"
PROVISIONING_PROFILE = "fdbb28f5-83e4-4f17-bad6-85ca4c8e60ba"
CONFIGURATION = "Adhoc"
SDK = "iphoneos"
SCHEMENAME = "HeXunMaster"

# configuration for pgyer
PGYER_UPLOAD_URL = "http://www.pgyer.com/apiv1/app/upload"
DOWNLOAD_BASE_URL = "http://www.pgyer.com"
USER_KEY = "ec296fb04a8611cbfbcc7e9df0400b17"
API_KEY = "66704b13ed14cc55f319eae0bd4f1126"

def cleanBuildDir(buildDir):
	cleanCmd = "rm -r %s" %(buildDir)
	process = subprocess.Popen(cleanCmd, shell = True)
	process.wait()
	print ("cleaned buildDir: %s" %(buildDir))

#def parserUploadResult(jsonResult):
#	resultCode = jsonResult['code']
#	if resultCode == 0:
#		downUrl = DOWNLOAD_BASE_URL +"/"+jsonResult['data']['appShortcutUrl']
#		print ("Upload Success")
#		print ("DownUrl is:" + downUrl)
#	else:
#		print ("Upload Fail!")
#		print ("Reason:"+jsonResult['message'])
#
#def uploadIpaToPgyer(ipaPath):
#    print ("ipaPath:"+ipaPath)
#    files = {'file': open(ipaPath, 'rb')}
#    headers = {'enctype':'multipart/form-data'}
#    payload = {'uKey':USER_KEY,'_api_key':API_KEY,'publishRange':'2','isPublishToPublic':'2', 'password':''}
#    print ("uploading....")
#    r = requests.post(PGYER_UPLOAD_URL, data = payload ,files=files,headers=headers)
#    if r.status_code == requests.codes.ok:
#         result = r.json()
#         parserUploadResult(result)
#    else:
#        print ('HTTPError,Code:'+r.status_code)

def buildWorkspace(isupload):
	workspace = SCHEMENAME + ".xcworkspace"
	timeStr = getTimeStr()
	versionStr = getVersionStr()
	outputfilepath = "/Users/wangmingzhu/Desktop/packet/%s/HeXunMaster_iOS_V%s_%s_%s" %(SCHEMENAME, versionStr, timeStr, CONFIGURATION)
#    print (outputfilepath)
	process = subprocess.Popen("pwd", stdout=subprocess.PIPE)
	(stdoutdata, stderrdata) = process.communicate()
	buildDir = stdoutdata.strip().decode() + '/build'
	print ("buildDir: " + buildDir)
#	buildCmd = 'xcodebuild -workspace %s -scheme %s -sdk %s -configuration %s build CODE_SIGN_IDENTITY="%s" PROVISIONING_PROFILE="%s" SYMROOT=%s' %(workspace, SCHEMENAME, SDK, CONFIGURATION, CODE_SIGN_IDENTITY, PROVISIONING_PROFILE, buildDir)
	archivePath = "/Users/wangmingzhu/Desktop/packet/%s/HeXunMaster_iOS_V%s_%s_%s.xcarchive" %(SCHEMENAME, versionStr, timeStr, CONFIGURATION)
	buildCmd = " xcodebuild -workspace %s -scheme %s clean archive -archivePath %s" %(workspace, SCHEMENAME, archivePath)
	process = subprocess.Popen(buildCmd, shell = True)
	process.wait()
#	signApp = "./build/%s-iphoneos/%s.app" %(CONFIGURATION, SCHEMENAME)
#	signCmd = "xcrun -sdk %s -v PackageApplication %s -o %s" %(SDK, signApp, outputfilepath)
	exportPlistPath = "/Users/wangmingzhu/Desktop/packet/%s/exportPlist.plist" %(SCHEMENAME)
	signCmd = "xcodebuild -exportArchive -archivePath %s -exportPath %s -exportOptionsPlist %s " %(archivePath, outputfilepath, exportPlistPath)
	process = subprocess.Popen(signCmd, shell=True)
	(stdoutdata, stderrdata) = process.communicate()

#	if isupload is None:
#		uploadIpaToPgyer(outputfilepath + "/%s.ipa" %(SCHEMENAME))
#	elif isupload is not None:
#		pass

	cleanBuildDir(buildDir)

def xcbuild(options):
	#run = options.run
	isupload = options.upload

	# if run is None:
	# 	run = "AdhocDev"
	# elif run is not None:
	# 	run = "AdhocDis"

	buildWorkspace(isupload)

def getTimeStr():
	now = int(time.time())
	timeArray = time.localtime(now)
	otherstyleTime = time.strftime("%Y%m%d%H%M", timeArray)
	return otherstyleTime

def getVersionStr():
	listPath = "./%s/Info.plist" %(SCHEMENAME)
	plist = plist_to_dictionary(listPath)
	version = plist['CFBundleShortVersionString']
	version = version.replace(".", "_")
	return version

def plist_to_dictionary(filename):
    "Pipe the binary plist through plutil and parse the JSON output"
    with open(filename, "rb") as f:
        content = f.read()
    args = ["plutil", "-convert", "json", "-o", "-", "--", "-"]
    p = Popen(args, stdin=PIPE, stdout=PIPE)
    out, err = p.communicate(content)
    return json.loads(out)

def main():

	parser = OptionParser()
#	parser.add_option("-r", "--run", help="specify Debug or Release", metavar="AdhocDev")
	parser.add_option("-u", "--upload", help="is upload to pgyer", metavar="pgyer")
	(options, args) = parser.parse_args()

	print ("options: %s, args: %s" % (options, args))
	xcbuild(options)

if __name__ == '__main__':
	main()
