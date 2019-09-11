package ecs;

import ecs.Message;

/**
  Mailbox the main method for sending messages to other object listening to the mail.
**/
class Mailbox {

    var listeners: Map<String, List<Message->Void>>;

    var queuedMessage: List<Message>;
    var dispatchStack: List<Message>;

    public function new() {
        listeners = new Map<String, List<Message->Void>>();
        dispatchStack = new List<Message>();
        queuedMessage = new List<Message>();
    }

    /**
      dispatch a message to the mailbox.

      if delayed is true, then the message will be queued and dispatched when the dispatchStack is empty.
    **/
    public function dispatch(message: Message, delayed: Bool=false) {
        // If delay is true and the stack is not empty, then we will queue it
        if (delayed && this.dispatchStack.length > 0) {
            this.queuedMessage.add(message);
            return;
        }

        // if delay is false or if the stack is already empty, we dispatch the message
        _dispatchMessage(message);

        // in theory, at this point the stack should be empty.
        // let's do a debug check just in case
        #if debug
        if (this.dispatchStack.length != 0) {
            throw "dispatchStack size should be 0";
        }
        #end

        if (this.dispatchStack.length == 0 && this.queuedMessage.length > 0){
            while (this.queuedMessage.length > 0) {
                var m = this.queuedMessage.pop();
                this._dispatchMessage(m);
            }
        }
    }

    /**
      private function for dispatching the message
    **/
    function _dispatchMessage(message: Message) {
        this.dispatchStack.push(message);
        var listeners = this.listeners.get(message.type);
        if (listeners != null) {
            for (listener in listeners) {
                listener(message);
            }
        }
        this.dispatchStack.pop();
    }

    /**
      listen to a message and provide a callback for handling the message
    **/
    public function listen(name: String, callback: Message->Void) {
        var functionList = this.listeners.get(name);
        if (functionList == null) {
            functionList = new List<Message->Void>();
            this.listeners[name] = functionList;
        }
        functionList.add(callback);
        // todo: return a listener id, and provide a function to remove the listener by id
    }
}

