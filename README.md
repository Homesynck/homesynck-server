# Homesynck server

## What is Homesynck? 
It's a real-time ordered data synchronisation tool.

Its main goals are scalability, reliability and security so that it fits most use cases.

It is free and open-source under MIT license. It can be self-hosted easily.

## What is real-time ordered data synchronisation?
Basically, when you're sending data from multiple places at the same time but you need to have it received and processed in the same order by everyone.

Order is not garanteed when things are done remotely and concurrently, Homesynck tries to enforce its own order so that everyone can agree on it.

Ordering problems can be critical when writing software. Here are some concrete examples:

- Remote file synchronisation
- Collaborative apps (e.g. Google Docs clones)
- Order-sensitive message exchanging (e.g. messaging apps)
- Turn-based video games

## How does it work?
Clients send messages to directories hosted on a Homesynck server. Homesynck takes note of the order in which it received messages for each directory. Then it sends messages back to clients connected to a directory and indicates in which order they should be processed.

Official clients, called SDKs, are available and can be imported into most pieces of software.

## Cool, let's get rolling!
- [Self-hosting guide](./docs/self_host_guide.md)
- [Check out existing SDKs](https://homesynck.anicetnougaret.fr/)
- [Make your hown client SDK guide](docs/channels_docs.md)