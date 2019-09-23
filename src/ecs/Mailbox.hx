package ecs;

import ecs.Message;

/**
  Mailbox the main method for sending messages to other object listening to the mail.
**/

typedef Listener = {
    var id: Int;
    var messageType: String;
    var callback: Message -> Void;
}

class Mailbox {

    var counter: Int = 0;

    var listeners: Map<Int, Listener>;
    var listenersMap: Map<String, List<Listener>>;

    var queuedMessage: List<Message>;
    var dispatchStack: List<Message>;

    public function new() {
        this.listeners = new Map<Int, Listener>();
        this.listenersMap = new Map<String, List<Listener>>();
        this.dispatchStack = new List<Message>();
        this.queuedMessage = new List<Message>();
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
        var listeners = this.listenersMap.get(message.type);
        if (listeners != null) {
            for (listener in listeners) {
                listener.callback(message);
            }
        }
        this.dispatchStack.pop();
    }

    /**
      listen to a message and provide a callback for handling the message
    **/
    public function listen(messageType: String, callback: Message->Void): Int {
        var listener = {
            id: this.counter++,
            messageType: messageType,
            callback: callback,
        }
        var functionList = this.listenersMap.get(messageType);
        if (functionList == null) {
            functionList = new List<Listener>();
            this.listenersMap[messageType] = functionList;
        }
        functionList.add(listener);
        this.listeners[listener.id] = listener;
        return listener.id;
    }
    /**
      remove a listener from the mailbox
    **/
    public function remove(id: Int) {
        var listener = this.listeners.get(id);
        if (listener == null) {
            return;
        }

        // should never be null
        var functionList = this.listenersMap.get(listener.messageType);

        functionList.remove(listener);
        this.listeners.remove(id);
    }
}

