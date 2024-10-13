class Audio {
	constructor(audioContext, elm) {
		// properties
		this.elm = elm;
		this.audioCtx = new audioContext();
		this.bgmVolume = 0.5;
		this.sfxVolume = 0.3;
		this.buffers =
			{ bgm: null
			, splat: null
			};
		this.sources =
			{ bgm: null
			, splat: null
			};
		
		// subscriptions
		this.elm.loadAudio.subscribe(() => this.loadAudioAssets());
		this.elm.playAudio.subscribe(name => this.playAudio(name));
		this.elm.setBGMVolume.subscribe(volume => this.setBGMVolume(volume));
		this.elm.setSFXVolume.subscribe(volume => this.setSFXVolume(volume));
		//this.elm.pauseAudio.subscribe(() => this.pauseBGM());
		//this.elm.stopAudio.subscribe(() => this.stopBGM());
	}

	setBGMVolume(volume) {
		this.bgmVolume = volume;
		if (this.sources.bgm) {
			this.sources.bgm.gain.value = volume;
		}
	}

	setSFXVolume(volume) {
		this.sfxVolume = volume;
	}


	loadAudioAssets() {
		this.loadAudio('bgm');
		this.loadAudio('splat');
	}

	loadAudio(name) {
		if (!codeFilenameMap[name]) {
			this.elm.assetError.send(`Unknown audio asset: ${name}`);
			return;
		}
		return fetch(codeFilenameMap[name])
			.then(response => response.arrayBuffer())
			.then(arrayBuffer => this.audioCtx.decodeAudioData(arrayBuffer))
			.then(audioBuffer => {
				this.buffers[name] = audioBuffer;
				this.elm.assetLoaded.send(name);
			})
			.catch(e => this.elm.assetError.send(`Unable to load audio clip ${name}: ${e.message}`));
	}



	playAudio(name) {
		if (!this.buffers[name]) {
			this.elm.assetError.send(`Error playing audio asset: ${name}`);
			return;
		}
		if (!volumeKey[name]) {
			this.elm.assetError.send(`Error setting volume for audio asset: ${name}`);
			return;
		}
		if (this.audioCtx.state === 'suspended') {
			this.audioCtx.resume();
		} 
		if (!this.sources[name]) {
			let source = this.audioCtx.createBufferSource();
			let gain = this.audioCtx.createGain();
			gain.gain.value = this[volumeKey[name]];
			source.buffer = this.buffers[name];
			source.connect(gain).connect(this.audioCtx.destination);
			source.start();
			this.sources[name] = source;
			window.setTimeout(() => {
				this.sources[name] = null;
				this.elm.audioComplete.send(name);
			}, this.buffers[name].duration * 1000);
		}
	}

	
	stopBGM() {
		this.sources.bgm.stop();
	}

	pauseBGM() {
		this.audioCtx.suspend();
	}
}

const codeFilenameMap = {
	'bgm': 'assets/bgm/Project.m4a',
	'splat': 'assets/sfx/splat.wav'
};

const volumeKey = {
	'bgm': 'bgmVolume',
	'splat': 'sfxVolume'
};
