# aspectTagger
Tag square and panoramic images to easily find Instagram photos, profile pictures, color/bump/normal/etc. maps, tiling textures, panoramic vacation photos and more. Once images are tagged, set even more specific tags like ‘instagram’ or ‘specular maps’ to make searching a breeze!

### Synopsis
aspectTagger - A bash script to tag square and panoramic images. 
<dl>
  <dt> usage: <br>
    <dd> -m | --mode <simple||monitor> <path> &nbsp;&nbsp;  Choose to run once or constantly as a background process. <br>
  <dt> additional options: <br>
      <dd>  -v | --verbose  &nbsp;&nbsp;    Display completion statements while running <br>
      </dl>
  Default mode is simple and default root is ~. 
  
### Code Example
Run for home directory: 
./aspectTagger.sh 

Run for a specific directory: 
./aspectTagger.sh ~/SomeDir

Run monitor mode on verbose:
./aspectTagger.sh -m monitor -v

Note: asptag.sh can be run by itself, but is meant more as a helper file. 

### Motivation
Finder can filter by portrait or landscape orientation, but panoramic and square photos are more specific (and useful) targets. After searching for solutions, the best I could find was <a href="https://discussions.apple.com/thread/3838377?start=0&amp;amp;tstart=0">this</a>. However, the script provided doesn’t work for me for a few reasons:
<ul>
<li>It changes the filenames rather than just tagging the images
<li>I wanted to exclude the system files contained in my Library folder, icons, and small UI elements. 
<li>I wanted to use multiprocessing to make tagging faster
<li>It only works for square images.
<li>You have to directly select the files you want to update, and there's no way to automate tag upkeep.
</ul>
The mdfind command allows for extremely fast metadata searches, so it makes sense to take advantage of that. The fswatch command is useful for automating this process and keeping a low profile when not in use.

### Installation
<ol>
<li>Download or clone aspectTagger.
<li>Open Terminal and navigate to where you’ve downloaded the scripts
<li>You may need to run chmod u+x aspectTagger.sh asptag.sh
<li>Install <a href="https://github.com/jdberry/tag">tag</a> using your preferred method
</ol>

### Requirements
OSX Mavericks 10.9 or higher (tested on OSX Yosemite 10.10.5 and OSX Mavericks 10.9.5). 

### Performance 
For a home directory containing 22,000 image files, 127 images were tagged in 
real	0m13.290s
user	0m0.127s
sys	0m0.322s
Subsequent runs returned times consistent with the above.

### Contact
Please feel free to let me know of any issues or suggestions at sm_zellner@msn.com.
