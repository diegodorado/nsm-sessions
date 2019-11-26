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
	~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
	s.sync;
	// load samples (path containing a wildcard can be passed in)
	~dirt.loadSoundFiles("/home/diegodorado/Music/tidal/samples/long-samples/*");
  ~dirt.loadSoundFiles("/home/diegodorado/Music/tidal/samples/misc-samples/*");

  s.sync; // wait for samples to be read
	~dirt.start(57120, [0, 0, 0, 2]);

  MIDIClient.init;

  ~midiThrough = MIDIOut.newByName("Midi Through", "Midi Through Port-0");
  ~midiThrough.latency = 0.0;
  ~dirt.soundLibrary.addMIDI(\midi, ~midiThrough);

  "/home/diegodorado/Music/tidal/tidal-synths/loadAll.scd".load();

};

s.latency = 0.2;



/*
n  = NetAddr("127.0.0.1",3333);
~dirt.receiveAction = { |e|
 
    if ( e.at(\emoji).isNil,{e[\emoji]=0},{});
 
    if ( e.at(\emoji)>0  ,
        {
            n.sendMsg("/emoji",
                e.at(\emoji),
                e.at(\cycle),
                e.at(\cps),
                e.at(\delta),
                e.at(\latency),
                e.at(\z_order));
            //e.postln;
        },
        {}
    );
};

*/

);
