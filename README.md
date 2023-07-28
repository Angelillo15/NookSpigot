# PandaSpigot [![Build](https://img.shields.io/github/actions/workflow/status/Angelillo15/NookSpigot/build.yml?branch=master&label=Build)](https://github.com/Angelillo15/NookSpigot/actions/workflows/build.yml) [![Discord](https://img.shields.io/discord/918181438879305748?label=Discord)](https://discord.nookure.com)
Fork of Paper for 1.8.8 focused on improved performance and stability.

## Highlights
- **Backported API enhancements from newer versions**
    - ServerTickStartEvent & ServerTickEndEvent
    - PlayerChunkLoadEvent & PlayerChunkUnloadEvent
    - PlayerHandshakeEvent
    - EntityMoveEvent

- **Greatly improved network performance**
    - **Updating to Netty 4.1** offers the ability to use newer Java versions with epoll on Linux.
    - **Improved flush handling** to massively improve entity tracker performance.
    - **Support for Unix domain sockets** to avoid the overhead of TCP when using a proxy on the same machine.
    - **Using LazyRunnables** to avoid expensive thread wakeup calls when sending non-flushed packets.

- **More configuration options**, such as:
    - Customizable knockback
    - World and player data saving

See a full list of patches [here](./patches/).

## Using
You can download the latest pre-built artifact [here](https://nightly.link/Angelillo15/NookSpigot/workflows/build/master/NookSpigot.zip).

For support, please join our [Discord](https://discord.nookure.com/).


## Building
To compile NookSpigot, you'll need:
- JDK 8 (or above)
- Git
- Bash

Building, patching, and compiling are all done through the main `nook` script.

PandaSpigot can be built by running `./nook jar`, and you will find the final Paperclip jar in `paperclip.jar`

## Contributing
You can mostly follow [Paper's contributing guide](https://github.com/PaperMC/Paper/blob/ver/1.16.5/CONTRIBUTING.md), just remember:
- Multi-line changes start with `// NookSpigot start` and end with `// NookSpigot end`
- If the change isn't obvious, add a small explanation like this: `// NookSpigot start - reason`
- One-line changes should have `// NookSpigot` at the end of the line.
- Follow Java code style (aka. Oracle style), with some exceptions:
  - If you are modifying upstream files, keep your diff size minimal. Going over 80 characters per line is fine to make this happen.
  - When in doubt or the code around your change is in a clearly different style, use the same style as the surrounding code.

When contributing, please think about the side effects of any changes you write.
Plugin compatibility is important, and we wish to minimize any breakage.

Please do not open pull requests for features that you cannot justify the existence of,
and the added maintenance costs of that come along with them. If you are thinking of
adding a feature that may be controversial, please open an issue first!
