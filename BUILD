BetweenAS3 Build Documentation
========================================

How to craete a swc file
--------------------

1. Install Flex SDK (3.3 or later) and Apache ANT

Flex SDK can be get at:
http://opensource.adobe.com/wiki/display/flexsdk/Download+Flex+3

Download a ZIP and unzip it to somewhere you like.

Note: An offical binary is created by the Adobe Flex SDK 3.3.0.4589

Apache ANT can be get at:
http://ant.apache.org/bindownload.cgi

Download a binary distribution and install it.

Note: If you're using Mac OSX 10.5, it was installed by default.


2. Configure FLEX_HOME variable

Open a build.properties in the BetweenAS3 project directory,
and edit FLEX_HOME variable to indicates a path to your Flex SDK that
was installed at step1.

Like:

 FLEX_HOME=/Users/yossy/DataFiles/Libraries/flex_sdk_3.3.0.4589/

to

 FLEX_HOME=/path/to/flex_sdk/


3. Run build command

Open your console, change the current directory to the BetweenAS3 project
directory, and execute following ANT command:

 $ ant -lib /path/to/flex_sdk/ant/lib/flexTasks.jar swc.fp10

Note: /path/to/flex_sdk/ is a path to your Flex SDK, same as FLEX_HOME.

If you want a SWC for FlashPlayer9, execute following command instead:

 $ ant -lib /path/to/flex_sdk/ant/lib/flexTasks.jar swc.fp9

A SWC file will be created at bin/BetweenAS3-<version>-<fp9|fp10>.swc