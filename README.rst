SHIS (Simple HTTP Interface Script)
===================================

This perl script provides a simple way to
interface with HTTP endpoints (REST APIs, etc.).

Usage
------

.. code: shell
    $ perl ./shis.pl [-verb=VERB] [-url=URL] [-data=DATA]

- VERB is one of the basic HTTP verbs (get, post, push, patch, or delete). Anything else (or nothing) will default to a GET.
- URL is the URL of the endpoint, it doesn't matter if it has a scheme on the front of it or not, the script will fill in the blanks.
- DATA is a string of raw JSON data that will be encoded and sent to the endpoint.

.. code: shell
    $ perl ./shis.pl -url https://example.com

.. code: shell
    $ perl ./shis.pl -verb post -url https://example.com -data '{"key": "value", "hi": "hello"}'
    
.. code: shell
    $ perl ./shis.pl -verb patch -url https://example.com -data '{"key": "value", "hi": "goodbye"}'

Installation
------------

FIXME:
