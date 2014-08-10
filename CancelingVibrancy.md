Canceling Vibrancy
------------------

In iOS 8 beta 1 you could cancel the vibrancy effect with a UILabel whose text color is rendered invisible with the blur effect underneath.

<img src="Screenshots/CancelUIVibrancyEffect.png" width="320" height="568" alt="Screenshot">

For an "invisible" text color, you could use white for extra light or light blur and black for dark blur. Add the UILabel to a vibrancy UIVisualEffectView's contentView and position it on top of vibrant text or a vibrant image.
