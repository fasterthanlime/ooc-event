use event
include event

import os/FileDescriptor

EvCallback: class {
    f: Func (FileDescriptor, Short)

    init: func (=f)
}

event_thunk: func (fd: FileDescriptor, ev: Short, arg: Pointer) {
    cb := arg as EvCallback 
    cb f(fd, ev)
}

Event: cover from struct event {
    READ   : extern(EV_READ   ) static Int
    WRITE  : extern(EV_WRITE  ) static Int
    PERSIST: extern(EV_PERSIST) static Int

    // stack allocation
    new: static func -> This { e: This; e }

    set: func@ (fd: FileDescriptor, flags: Int, f: Func (FileDescriptor, Short)) {
	event_set(this&, fd, flags, event_thunk, EvCallback new(f))
    }

    add: extern(event_add) func@ (timeout := null)

}

event_set: extern func (Event*, FileDescriptor, Int, Pointer, Pointer)

EventBase: cover from struct event_base* {

    new: static extern(event_base_new) func -> This

    set: extern(event_base_set) func (ev: Event*)
    dispatch: extern(event_base_dispatch) func -> Int

}

