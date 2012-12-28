# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
root = exports ? this
root.addTaskPlan =  (x) -> 
	$('.links').before('<tr class="ts">    
		<td><textarea class="taskplan" id="task_triplet_'+x+'_1" name="task_triplet['+x+'][1]"></textarea></td>
    <td><img alt="Arrow" src="/assets/arrow.png"></td>
    <td><textarea class="taskplan" id="task_triplet_'+x+'_2" name="task_triplet['+x+'][2]"></textarea></td>
    <td><img alt="Arrow" src="/assets/arrow.png"></td>
    <td><textarea class="taskplan" id="task_triplet_'+x+'_3" name="task_triplet['+x+'][3]"></textarea></td>
    <td><a href="#" onclick=" $(this).parent().parent().remove(); return false;"><img alt="Close" src="/assets/close.png"></a></td>

</tr>')