#Colifrapy

##Description
Colifrapy is a **Command Line Framework for Python**.
Its aim is to provide several tools to build robust and
structured command line tools very easily.

Its logic is very similar to a MVC framework and is therefore easy to use.

A more visually appealing documentation is available [there](http://yomguithereal.github.io/colifrapy/)

##Summary
* [Installation](#installation)
* [Philosophy](#philosophy)
* [Concept](#concept)
* [Usage](#usage)
	1. [Scaffolding](#scaffolding)
	2. [Command Line Hub](#command-line-hub)
	3. [Controller](#controller)
	4. [Settings](#settings)
	5. [Arguments](#arguments)
	6. [Model](#model)
	7. [Logger](#logger)
	8. [Eye Candy](#eye-candy)
	9. [Bonus](#bonus)
* [Examples](#examples)
* [Dependencies](#dependencies)
* [License](#license)

##Installation
It is recommanded to use colifrapy under a python virtualenv.

Install it with pip (version up to 0.3.0):

```
pip install colifrapy
```

If you want to use the latest one which is still in development :

```
pip install git+https://github.com/Yomguithereal/colifrapy.git
```

##Philosophy
As every framework, colifrapy aims at enable you to work immediately on critical and intersting parts of
your code that will tackle the problems you need to solve instead of battling with petty
things such as the console output, your settings and the arguments passed to your tool.

However, colifrapy is not a tyrant and does not force you to go its way. As such, every part of colifrapy can
be used on its own and you will remain free to code however you want to.

##Concept
When using colifrapy, your tool is called through a command line hub which acts more or less like a router and
calls upon a controller that will use one or several models to perform the job.

Your hub has therefore the task to load a yaml configuration file containing your command line
arguments, name, version and even contextual settings if you need to.

Once those settings are loaded, every part of your application (mainly models) will remain able to access critical
utilities such as argv opts, settings and make use of colifrapy's logger to ouptut nicely to the console.

So, schematically colifrapy is:

	Settings --> Command Line Hub --> Controller --> Model + Model + Model etc...

Every bit of colifrapy can be used as a standalone.

	Logger (outputs to console)
	Settings (deals with your yml settings)
	Commander (deals with argv)

##Usage

###Scaffolding
Colifrapy is able to create a new blank project for you.

```sh
colifrapy new [project]

# Options
#    -a/--author [name] : name of the project's author
#    -o/--organization [name] : name of the author's organization
```

This will create the necessary files to start working immediatly. I.e. a command line hub, a base
controller, an example model, a config file, a string file and other frequent files such as .gitignore and such.

To test if the scaffolding has worked :
```sh
cd [project]
python [project].py test
```

It should output a header displaying your project's title, some string outputs, and a short line telling you
all is going to be fine.

---

###Command Line Hub
A colifrapy project relies on a command line hub which extends Colifrapy base class and which must
be called from the root of your project. The duty of this hub is just to launch your tool, analyze
the arguments given to it and call upon the relevant controller methods.

In fact, this hub can be compared to a basic router for web frameworks.

This is the hub as generated by the scaffolder :

```python
# Dependencies
#=============
from colifrapy import Colifrapy
from model.controller import Controller

# Hub
#======
class NameOfYourProject(Colifrapy):

    # From this hub, you can access several things :
	#    self.settings (Settings Instance)
	#    self.log (Logger Instance)
	#    self.opts (Options passed to your hub)
	#    self.controller (Your Controller)

    def launch(self):

        # Welcoming visitors
        self.log.header('main:title')

        # Calling upon the controller
        self.controller.test()

# Launching
#===========
if __name__ == '__main__':
	# By default, the hub will load config/settings.yml
    hub = NameOfYourProject(Controller, [optional]'path/to/your/settings.yml')
    hub.launch()
```

---

###Controller
The controller is a class that will call upon your models to perform actions. It is in fact a colifrapy Model instance, but this must not disturb you.

The controller is totally optional and just illustrate a
way to organize your code.
If you don't want to follow this logic, just don't pass a controller to your hub instance.

Controller as generated by the scaffolder:

```python
# Dependencies
#=============
from colifrapy import Model
from example_model import ExampleModel

# Main Class
#=============
class Controller(Model):

    # Properties
    example_model = None

    def __init__(self):
        self.example_model = ExampleModel()

    # Example of controller action
    def test(self):
        self.log.write('main:controller')
        self.example_model.hello()
```

---


###Settings
The Settings class is the first class loaded by colifrapy to perform its magic. It will parse your settings.yml file and configure your logger, arguments and every other configuration you want for your application.

config/settings.yml file:

```yaml
# Basic Informations
version: '[project-name] 0.1.0'
description: 'Description of the program.'
usage: 'How to deal with your program'
arguments:
- [ ['-t', '--test'], {'help' : 'Test', 'type' : 'int'} ]
- [ ['positionnal'] ]

# Logger Settings
logger:
    strings: 'config/strings.yml'
    flavor: 'default'
    title_default: 'default'
    # Delete the path line not to write the log to a file
    path: 'logs'
    threshold: ['DEBUG', 'ERROR', 'INFO', 'WARNING', 'VERBOSE']

# Generic Settings needed by your program
settings:
    hello: 'world'
    bonjour: 3.4
    hash: {'test' : 2}
```

The settings are loaded automatically by colifrapy but you still can use its logic elsewhere if
you need it.

```python
# Importing
from colifrapy import Settings

# Instanciating settings
settings = Settings()

# Let the path blank to fetch 'config/settings.yml' by default
settings.load('path/to/your/settings.yml')

# Now use it
print settings.hello
>>> 'world'

print settings.hash['test']
>>> 2
```

The Settings class is a singleton. You can therefore use it everywhere without having to reload the data.

---

###Arguments
Arguments are to be defined as for the python [ArgParser](http://docs.python.org/dev/library/argparse.html "ArgParser") class. In fact,
the colifrapy Commander class extends the ArgParser one, so, if you need complicated things not handled by colifrapy, just use the Commander class like the ArgParser one.

```yaml
arguments:
- [ ['-t', '--test'], {'help' : 'Test', 'type' : 'int', 'default' : 5} ]
- [ ['-b', '--blue'], {'help' : 'Blue option', 'type' : 'int', 'required' : 'True'} ]
- [ ['some_positionnal_argument'] ]
```

Once the settings are loaded, you can access your options through:
```python
from colifrapy import Commander
command = Commander()

print command.opts.test
>>> 5

As for standard python command line tool, yours will accept three default arguments you should not try to override. Those are
-v/--version (outputting your program's version), -h/--help (displaying your program's help) and -V/--verbose (overriding settings to
enable the logger to display every messages).

# Or from a hub/model
print self.opts.test
>>> 5
```
As for the Settings class, the Commander class is a singleton and its state won't change if you load it elsewhere.

In the command hub and in your models, you can access the options passed to your commander through
self.opts . However, even if those are accessible in models for commodity, only the main hub should use them and one should restrain their usage in models.


---


###Model
Models are the bulk of Colifrapy. You can extend them to acces your settings and commands easily.

An example model is generated for you by the Scaffolder when you create a new project.

```python
from colifrapy import Model

class MyModel(Model):
	def test(self):
		print self.settings.hello

m = MyModel()
m.test()
>>> 'world'
```

Reserved attributes names are:

	log (access to the logger described right after)
	opts (access to the command line options)
	settings (access to the program's settings)


---

###Logger

####Basic
The logger is the outputting class of colifrapy. It should be loaded with some strings by the settings.
If no strings are given, the logger will just output normally the argument string you give to it.

####Levels
The logger accepts five levels :

	INFO (green output)
	VERBOSE (cyan output)
	DEBUG (blue output)
	WARNING (yellow ouput)
	ERROR (red output) --> will throw an exception for you to catch or not

By default, if no level is specified for a message, DEBUG will always be taken.

####Strings
Strings are externalized to enable you to quickly modify them if
needed, or even translate them easily.

The string format used is a mustache-like, so variables
come likewise : {{some_variable}}

Strings given must follow this yaml layout:
```yaml
main:
    process:
    	# String with a variable contained within the mustaches
        start: 'Starting corpus analysis (path : {{path}})//INFO'
        # Simply write two slashes at the end to specify the level of the message
        end: 'Exiting//WARNING'
        test_line_break: '\nBonjour'
    title: 'Colifrapy'
other_string_category:
	test: 'Hello everyone//INFO'
	you:
		can:
			make: 'any levels that you want'
			so: 'you can organize your strings however you need.'
```

####Usage
This is how you would use the logger in a colifrapy model:
```python
from colifrapy import Model

class MyModel(Model):
	def test(self):

		# Main method
		#------------

		# Outputting a message
		self.log.write('main:process:end')
		>>> '[WARNING] :: Exiting'

		# Overriding the message level
		self.log.write('main:process:end', 'INFO')
		>>> '[INFO] :: Exiting'



		# Passing variables
		self.log.write('main:protocol:start', {'path' : 'test'})
		>>> '[INFO] :: Starting corpus analysis (path : test)'

        # Variables can be passed to the logger as:
        # a hash, a list, a tuple, a single string or integer or float

        # Examples
        self.log.write('{{variable}}', 'test')
        >>> '[DEBUG] :: test'

        self.log.write('{{var1}} is {{var2}}', ['python', 'cool'])
        >>> '[DEBUG] :: python is cool'



		# When yml file is not specified or if message does not match
		self.log.write('Test string', level='DEBUG')
		>>> '[DEBUG] :: Test string'

		# Named arguments of write
		# variables --> mixed
		# level --> log level

		# Helper methods
		#---------------

		# Printing a header (yellow color by default)
		self.log.header('main:title', [optional]color)
		>>> Colifrapy
		>>> ---------

		# Write methods shorteners
		self.log.error(message, vars)
		self.log.warning(...)
		self.log.info(...)
		self.log.debug(...)
		self.log.verbose(...)


		# Confirmation
		#---------------

		# 'y' will be taken by default in arg 2
		# will return True for y and False for n
		response = self.log.confirm('Are you sure you want to continue?')
		>>> '[CONFIRM] :: Are you sure you want to continue? (Y/n)'
		>>> y --> True

		response = self.log.confirm('Are you sure you want to continue?', 'n')
		>>> '[CONFIRM] :: Are you sure you want to continue? (y/N)'
		>>> n --> False


		# User Input
		#---------------

		response = self.log.input('What up ?')
		>>> '[INPUT] :: What up ?'
		>>> 'feeling fine' --> 'feeling fine'

		# You can also provide a lambda to the function as second argument
		# This lambda will affect the input given
		response = self.log.input('What up ?', lambda x: x.upper())
		>>> '[INPUT] :: What up ?'
		>>> 'feeling fine' --> 'FEELING FINE'

```

####Configuration
You can pass some options to your logger within the settings.yml file.

```yaml
# Logger settings
logger:

    # Activation. Whether it will output to console?
    # defaults to True
    activated: True

    # Path to strings.
	strings: 'path/to/your/strings.yml'

	# optional, discard the line not to log to a file
	path: 'path/where/to/log/'

	# optional, use it to specify your logger threshold
	# ERROR will always be kept whatsoever for obvious reasons, even if you drop it
	log_threshold : ['DEBUG', 'ERROR']

	# optional (default, False), whether you want your errors to raise exceptions
	exceptions: False

	# flavors (see Eyecandy) you can drop those lines if you want default
	flavor: 'default'
	title_flavor: 'default'
```

####Standalone Usage
The Logger is also a singleton, you can use it as a standalone, if you need to :

```python
from colifrapy import Logger

log = Logger()

# If you haven't configured it before in your code and you use it outside colifrapy
# Pass kwargs to it corresponding to the logger options in settings.yml
log.config(**kwargs)

log.debug('test')
>> [DEBUG] :: test
```

---

###Eye Candy
Colifrapy logged messages come with visual alternatives. They are called
'flavors' and can be set in the Logger's settings.

Colors are enabled by default, even if I cannot show them there.

####Title Flavors:

#####default
```
Title
-----
```

#####heavy
```
#########
# Title #
#########
```

####Logger Flavors:

#####default
```
[DEBUG] :: text
```

#####flat
```
debug : text
```

#####colorblind
```
[DEBUG] :: text
# Without colors, obviously
```

#####reverse
```
 DEBUG  :: text
# With reverse colors, obviously
```

#####elegant
```
Debug - text
```

#####underline
```
DEBUG -- text
-----
```


---

###Bonus
Colifrapy also gives access to a colorization function, a custom exception class and a basic singleton decorator if needed.

```python
from colifrapy.tools.colorize import colorize
print colorize('hello', fore_color, background_color, style=list or string)

# Available colors : black, red, green, yellow, blue, magenta, cyan, white
# Available styles : reset, bold, dim, underline, blink, reverse, hidden

from colifrapy.tools.decorators import singleton

@singleton
class MySingleton():
	pass

# Custom Exception Carrying data
from colifrapy import DataException
raise DataException(message, data)
```

##Examples
My project [furuikeya](https://github.com/Yomguithereal/furuikeya) is a good example of the usage
of colifrapy since colifrapy was originally designed to help me doing it.

##Dependencies

	pyyaml

##License
Colifrapy is under a MIT license.