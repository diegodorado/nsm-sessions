(
"SC_JACK_DEFAULT_INPUTS".setenv("");
"SC_JACK_DEFAULT_OUTPUTS".setenv("");

s.options.numBuffers = 1024 * 32; // increase this if you need to load more samples
s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 4; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 8;

s.options.maxLogins=4;


s.waitForBoot {
	~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
	//~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
	s.sync;
	// load samples (path containing a wildcard can be passed in)
	//~dirt.loadSoundFiles("/home/diegodorado/Music/tidal/samples/long-samples/*");
    ~dirt.loadSoundFiles("/home/diegodorado/Music/tidal/samples/trap-samples/*");
    ~dirt.loadSoundFiles("/home/diegodorado/Music/tidal/samples/misc-samples/*");

    s.sync; // wait for samples to be read
	~dirt.start(57120, [0, 0, 0, 0]);

    
    n = NetAddr("127.0.0.1", 6666);
    ~dirt.startSendRMS;
    OSCFunc({ |msg|
	    defer {
            n.sendMsg("/rms", msg);
	    }
    }, "/rms");


    MIDIClient.init;

    ~midiThrough = MIDIOut.newByName("Midi Through", "Midi Through Port-0");
    ~midiThrough.latency = 0.0;
    ~dirt.soundLibrary.addMIDI(\midi, ~midiThrough);

};

s.latency = 0.2;



);


