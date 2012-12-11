# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
root = exports ? this
root.addTask =  (x) -> 
	$('.links').before('<tr class="ts">    
		<td><textarea class="task" id="task_supply_'+x+'_1" name="task_supply['+x+'][1]"></textarea></td>
    <td><img alt="Arrow" src="/assets/arrow.png"></td>
    <td><textarea class="task" id="task_supply_'+x+'_2" name="task_supply['+x+'][2]"></textarea></td>
    <td><a href="#" onclick=" $(this).parent().parent().remove(); return false;"><img alt="Close" src="/assets/close.png"></a></td>

</tr>')

