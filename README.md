# aspectTagger
Tag square and panoramic images to easily find Instagram photos, profile pictures, color/bump/normal/etc. maps, tiling textures, panoramic vacation photos and more. Once images are tagged, set even more specific tags like ‘instagram’ or ‘specular maps’ to make searching a breeze!

### Synopsis
aspectTagger - A bash script to tag square and panoramic images. 
<dl>
  <dt> usage: <br>
    <dd> -m | --mode <simple||monitor> <path> &emsp; Choose to run once or constantly as a background process. <br>
  <dt> additional options: <br>
      <dd>  -v | --verbose  &emsp; Display completion statements while running <br>
      </dl>
  Default mode is simple and default root is ~. 
  
### Code Example
<dl>
<dt>Run for home directory: <br>
<dd>./aspectTagger.sh 

<dt>Run for a specific directory: <br>
<dd>./aspectTagger.sh ~/SomeDir

<dt>Run monitor mode on verbose:<br>
<dd>./aspectTagger.sh -m monitor -v
</dl>
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
The mdfind command allows for extremely fast metadata searches, so it makes sense to take advantage of that. The fswatch command is useful for automating this process and keeping a low profile when not in use. This sort of file crawler can easily be expanded to assign new tags. 

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
Finding and tagging 203/22,200 images took an average time of <br>
real &emsp; 3m44.554s <br>
user &emsp; 0m0.121s <br>
sys &emsp; 0m0.268s <br>

Real-time results improve significantly (see below) if processes are spawned from asptag.sh, but it tends to exceed the maximum number of processes allowed (ulimit -a to see your user process cap; mine is 709). This happens for deeply-nested, large folders usually belonging to applications. If you don't have any folders like that, you can make the change recommended in the file for a much faster completion time and even run it more than once to catch a few extra files if that makes you happy. Finding and tagging an average of 126/22,200 images took an average time of <br>
real &emsp; 0m12.614s <br>
user &emsp; 0m0.120s <br>
sys &emsp; 0m0.276s <br><br>

There is no significant difference in user and system time, but real-time results are almost 18x faster. 

### Contact
Please feel free to let me know of any issues or suggestions at sm_zellner@msn.com.
