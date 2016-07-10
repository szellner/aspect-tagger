# aspectTagger
A bash script that tags square and panoramic images.
### Synopsis
Easily find Instagram photos, profile pictures, color/bump/normal/etc. maps, tiling textures, panoramic vacation photos and more. Once images are tagged, set even more specific tags like ‘instagram’ or ‘specular maps’ to make searching a breeze!

### Code Example
Run for home directory (the default root): 
./aspectTagger.sh 

Run for a specific folder: 
./aspectTagger.sh ~/SomeFolder

Note: tag.sh can be run by itself, but is meant more as a helper file. 

### Motivation
Finder can filter by portrait or landscape orientation, but panoramic and square photos are more specific (and useful) targets. After searching for solutions, the best I could find was <a href="https://discussions.apple.com/thread/3838377?start=0&amp;amp;tstart=0">this</a>. However, the script provided doesn’t work for me for a few reasons:
<ul>
<li>It changes the filenames rather than just tagging the images
<li>I wanted to exclude the system files contained in my Library folder
<li>There’s no way to exclude icons and small UI elements
<li>I wanted to use multiprocessing to make tagging faster
<li>It only works for square images.
</ul>
The mdfind command allows for extremely fast metadata searches, so it makes sense to take advantage of that and automate this process to save myself time. 

### Installation
<ol>
<li>Download or clone aspectTagger.
<li>Open Terminal and navigate to where you’ve downloaded the scripts
<li>You may need to run chmod u+x aspectTagger.sh tag.sh
<li>Install <a href="https://github.com/jdberry/tag">tag</a> using your preferred method
</ol>

### Requirements
OSX Mavericks 10.9 or higher (tested on OSX Yosemite 10.10.5 and OSX Mavericks 10.9.5).

### Contact
Please feel free to let me know of any issues or suggestions at sm_zellner@msn.com.
