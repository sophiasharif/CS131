# Assessing asyncio's Suitability for Application Server Herds

## Introduction

This report details the effectiveness of using the Python module asyncio to implement a server herd, focusing on a proxy herd for the Google Places API. We address concerns regarding asyncio's compatibility, performance, and maintenance for rapid data exchange among servers in a mobile client context.

## Python vs. Java for Server Herd

### Typechecking

Python is a dynamically typed language, while Java is statically typed. Statically typed languages require variable types to be declared which can help catch errors at compile time at the cost of verbosity and ease of development. Python's dynamic typing can make it easier to write code quickly but can also make it less reliable. Overall, Python's typing offers more flexibility and allows for faster development, while Java's typing offers more reliability and can reduce runtime errors.

### Memory Managment

Both Python and Java use garbage collection to manage memory, but they have different approaches: Python uses reference counting and a cycle detector, while Java uses a generational garbage collector. Python's memory management is simpler but can lead to unpredictable pauses, while Java's memory management is more complex but can be more efficient. Python's model is preferable for rapid development, while Java's model is preferable for performance-critical applications.

### Multithreading

Python's Global Interpreter Lock (GIL) limits native threads to executing one at a time, which prevents true parallelism. Java's threads can run in parallel, allowing for better performance on multi-core systems. Python's GIL can be bypassed using multiprocessing, but this adds complexity to the code.

This can be a benefit or a drawback depending on the application. For CPU-bound applications where parallelism is important, Java's multithreading is a better choice. For I/O-bound applications, Python's asynchronous programming significantly simplifies development and prevents complciated bugs, so it is the better choice.

## Asyncio

Asyncio is a module in Python that provides a way to write concurrent code using the async/await syntax, allowing for non-blocking code execution. This means that the code can continue to execute while waiting for I/O operations to complete. This is useful for writing code that needs to perform I/O operations such as reading from a file or making a network request.

### Concurrency

Asyncio provides and event loop that manages the execution of coroutines (functions that can be paused an resumed), allowing for efficient I/O operations. This enables high concurrency in I/O-bound applications, but does not provide true parallelism for CPU-bound applications.

### Ease of Use

Asyncio is easy to use and well-suited for I/O bound applications. To declare a coroutine, simply use the `async` keyword. To call a coroutine, use the `await` keyword. The top-level entry point for an asyncio program is the `asyncio.run` function. Here is a simple example from the asyncio documentation:

```python
import asyncio
import time

async def say_after(delay, what):
    await asyncio.sleep(delay)
    print(what)

async def main():
    print(f"started at {time.strftime('%X')}")

    await say_after(1, 'hello')
    await say_after(2, 'world')

    print(f"finished at {time.strftime('%X')}")

asyncio.run(main())
```

If run synchronously, this code would take 3 seconds to run. However, because the `say_after` coroutines are called asynchronously, the code will print "hello" after 1 second, and "world" after 2 seconds. The syntax is easy to understand and maintain in larger codebases.

### Performance

Asyncio excels in I/O-bound applications but is useless for CPU-bound applications. This makes it a good choice for the Google Places API proxy herd, where requests to the API are the bottleneck. However, it is less suitable for CPU-bound applications; under the GIL model only one thread can execute at a time, so ayncio's coroutines cannot take advantage of multiple CPU cores.

### asyncio features of Python 3.9 or later

Asyncio features of Python 3.9 or later, like `asyncio.run` and `python3 -m asyncio`, significantly enhance the developer experience. The `asyncio.run` is an easy way to define the entry point for an asyncio program, and the `python3 -m asyncio` command makes it easy to run asyncio programs from the command line. Python 3.7 and 3.8 also support asyncio, but require more boilerplate code to run an asyncio program. Because of this, Python 3.9 or later is preferable for developing asyncio programs.

## Asyncio vs. Other Frameworks

### Java

Java's threading model offers more raw performance for CPU-bound tasks due its ability to run threads in parallel on multiple CPU cores. However, this comes at the cost of complexity and potential bugs. Asyncio's coroutine-based model provides easier management of I/O-bound tasks, with lower overhead compared to Java's threads.

### Node.js

Node.js uses an event-driven, non-blocking I/O model similar to asyncio. Both Python and Node.js are best-suited for I/O-bound tasks and can similar tasks with similar performance.

There are some minor differences. Node.js presents the event loop as a runtime instead of a library, so there is no blocking call to start the event loop as there is in asyncio. Node.js is also asynchronous by default and uses callbacks, while Python is synchronous by default and uses coroutines.

## Problems Encountered

### Starting a Server

I was unfamiliar with the process of starting a server in asyncio. I had to learn how to use the `asyncio.start_server` function to create a server that listens for incoming connections. This function returns a `Server` object that can be used to accept incoming connections and handle them asynchronously.

### Debugging

Debugging was more difficult for this project than other projects we have worked on in this class. It was often difficult to trace the source of errors because there were 5 different points of execution, and I had to comb through logs to find the source of the error. 

One bug I encountered often was missing an await keyword. At first, I didn't catch these sorts of bugs because I wrapped my code in try/except blocks but didn't log the exception in depth. I learned from this by adding more detailed exception handling to my code, including the name of the function and the message of the exception.

One particularly difficult bug I encountered was when I noticed that some of my servers were receiving messages from server 10 according to my serialized path of ports. I was really confused where this was sourcing from because there was no server on port 10. After a lot of debugging, I noticed that all the messages were capped at 100 characters long. At this point, I realized that I was only reading 100 characters to the buffer at a time, and I was missing the rest of the message. I fixed this by reading the entire message to the buffer at once.

### Closing Connections

Another particularly frustrating bug I encountered was getting 3/60 on the autograder because I wasn't closing the connection with the client after receiving a message from them. I spent hours debugging this issue and couldn't figure out what was wrong. This was a one-line fix -- I just had to add `writer.close` after sending a message to the client. 

### Testing

Testing was difficult because I had to test the entire system at once. I couldn't test the servers in isolation because they relied on each other to function. This made it difficult to isolate the source of errors. I had to rely on logs to trace the source.

It was also frustrating to have to restart every single server every time I made a change to the code. This made the development process slow and tedious. I would have liked to have a way to restart the servers without having to manually stop and start them. In the future, if I find myself in a similar situation, I might try to write a shell script to start the 5 server for me and send a test message to them.


## Recommendation

Asyncio is highly suitable for creating a proxy server herd architecture, particularly for scenarios involving high I/O operations like the proposed proxy herd for the Google Places API. Its efficient handling of concurrent connections, ease of use due to the `async`/`await` syntax, and the improved features in Python 3.9 and later versions significantly outweigh the complexities involved in earlier versions. Although Python's dynamic typing and memory management approach, as well as the Global Interpreter Lock (GIL), present challenges in comparison to Java, these do not detract from asyncio's appropriateness for this application. The event-driven model employed by asyncio is akin to that of Node.js, offering similar benefits in terms of performance and scalability for I/O-bound tasks. Given these considerations, we recommend adopting asyncio for developing the application server herd, with a suggestion to leverage the latest Python features for optimal performance and maintainability. This choice is predicated on the project's I/O-bound nature and the necessity for rapid, efficient processing of network requests, where asyncio's event loop and coroutine model excel.
