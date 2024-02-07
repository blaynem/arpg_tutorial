extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]


func insert(newItem: InventoryItem):
	# Find slots that already contain the same item as the newItem, and can also hold more of it.
	var slotsWithItem = slots.filter(func(slot): return slot.item == newItem && slot.amount < newItem.maxStackSize)
	# All slots that are empty.
	var emptySlots = slots.filter(func(slot): return slot.item == null)

	# If there are no slots that can hold more of the newItem, and there are no empty slots we need to error out.
	if slotsWithItem.is_empty() and emptySlots.is_empty():
		print("Inventory is full")
		return
	
	# Because we filtered the slots array, we can be sure that the first element of the array is the first slot that can hold more of the newItem.
	if not slotsWithItem.is_empty():
		slotsWithItem[0].amount += 1
	# And if there are no slots with the newItem, we can be sure that the first element of the emptySlots array is the first empty slot.
	else:
		emptySlots[0].item = newItem
		emptySlots[0].amount = 1
	
	# Emit an 'updated' signal to notify other components of the inventory change.
	updated.emit()
