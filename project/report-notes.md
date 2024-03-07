# Asyncio for Server Herd

## Report Goals

Make a recommendation pro or con for using asyncio for server herd
Justify recommendation
Describe problems you ran into
Directly address bosses concerns about Python vs. Java
Compare overall approach of asyncio to Node.j
Focus on language-related issues
Ease of using asyncio-based programs that run and exploit server herds
Performance implications of asyncio
Importance to relying on features of asyncio introduced in python 3.9 and later (like asyncio.run and python3 -m asyncio) — how easy is to get by with older version of Python?

## Introduction

This report details the effectiveness of using the Python module asyncio to implement a server herd.

The server herd is a collection of servers that are managed by a single server. The single server is responsible for distributing tasks to the servers in the herd. The servers in the herd are responsible for executing the tasks and reporting the results back to the single server.

## Asyncio Basics

Asyncio is a module in Python that provides a way to write concurrent code using the async/await syntax. The async/await syntax allows for non-blocking code execution. This means that the code can continue to execute while waiting for I/O operations to complete. This is useful for writing code that needs to perform I/O operations such as reading from a file or making a network request.

### Coroutines

Coroutines are a key concept in asyncio. A coroutine is a function that can be paused and resumed. This allows for non-blocking code execution. Coroutines are defined using the async keyword.

### Advantages of Coroutines

Coroutines have several advantages over traditional threads. Coroutines are more lightweight than threads, which means that they are more efficient in terms of memory usage. Coroutines are also easier to work with than threads, as they take advantage of Python's global interpreter lock and thus avoid many of the pitfalls of working with threads.

Coroutines are also more flexible than threads. Coroutines can be paused and resumed at any time, which makes them well-suited for writing code that needs to perform I/O operations.

Coroutines are less useful for CPU-bound tasks, as they do not take advantage of multiple CPU cores. Because of this, they may not be great for tasks that require a lot of computation. However, for I/O-bound tasks, coroutines are an excellent choice.

### Coroutines in Asyncio

In asyncio, coroutines are used to define asynchronous functions. These functions can be paused and resumed using the await keyword. In asyncio, asynchrnous functions are defined using the async keyword and then called using the await keyword. The top-level entry point for an asyncio program is the asyncio.run function. Here is an example from the asyncio documentation that demonstrates the use of coroutines in asyncio:

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

### Event Loop

The event loop is a key concept in asyncio. The event loop is responsible for scheduling and running coroutines. The event loop is responsible for managing the execution of coroutines and ensuring that they are executed in the correct order. The event loop is also responsible for handling I/O operations and other asynchronous events.

### Tasks in Asyncio

Tasks are used to schedule coroutines to run concurrently. A task is created using the asyncio.create_task function. Here is an example from the asyncio documentation that demonstrates the use of tasks in asyncio:

```python
async def main():
    task1 = asyncio.create_task(
        say_after(1, 'hello'))

    task2 = asyncio.create_task(
        say_after(2, 'world'))

    print(f"started at {time.strftime('%X')}")

    # Wait until both tasks are completed (should take
    # around 2 seconds.)
    await task1
    await task2

    print(f"finished at {time.strftime('%X')}")
```

The output of this program would be:

```
started at 17:14:32
hello
world
finished at 17:14:34
```
