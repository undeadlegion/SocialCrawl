<?php
@require_once(dirname(__FILE__) . '/simpletest/autorun.php');

class AllTests extends TestSuite {
    function AllTests() {
        $this->TestSuite('All tests');
        $this->addFile('testAuthentication.php');
        $this->addFile('testUser.php');
        $this->addFile('testEvent.php');
        $this->addFile('testInteraction.php');
    }
}
?>