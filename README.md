# LVModalQueue
This fixes 'NSInternalInconsistencyException's when presentViewController: and dismissViewController: are called, while a transition is already in progress. Transitions are queued for later execution.
