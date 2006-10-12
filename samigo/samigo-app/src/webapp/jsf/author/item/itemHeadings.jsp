<%--
Headings for item edit pages, needs to have msg=AuthorMessages.properties.
--%>
<!--
* $Id$
<%--
***********************************************************************************
*
* Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
*
* Licensed under the Educational Community License, Version 1.0 (the"License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.opensource.org/licenses/ecl1.php
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License. 
*
**********************************************************************************/
--%>
-->
<script language="javascript" type="text/JavaScript">
<!--
function changeTypeLink(field){

var newindex = 0;
for (i=0; i<document.links.length; i++) {
  if ( document.links[i].id.indexOf("hiddenlink") >=0){
    newindex = i;
    break;
  }
}

document.links[newindex].onclick();
}

//-->
</script>
<h:form id="itemFormHeading">
<%-- The following hidden fields echo some of the data in the item form
     when this form posts a change in item type, the data is persisted.
     We don't keep the answers--probably misleading for the new type.
--%>
<%-- score --%>
<h:inputHidden value="#{itemauthor.currentItem.itemScore}" />
<%-- non-matching type questions --%>
<h:inputHidden value="#{itemauthor.currentItem.itemText}" />
<%-- matching questions --%>
<h:inputHidden value="#{itemauthor.currentItem.instruction}" />
<%-- feedback --%>
<h:inputHidden value="#{itemauthor.currentItem.corrFeedback}" />
<h:inputHidden value="#{itemauthor.currentItem.incorrFeedback}" />
<h:inputHidden value="#{itemauthor.currentItem.generalFeedback}" />
<%-- --%>
<p class="navIntraTool">
    <h:commandLink title="#{genMsg.t_assessment}" action="author" immediate="true">
      <h:outputText value="#{genMsg.assessment}" />
    </h:commandLink>
    <h:outputText value="#{genMsg.separator} " />
    <h:commandLink title="#{genMsg.t_template}" action="template" immediate="true">
      <h:outputText value="#{genMsg.template}" />
      <f:actionListener type="org.sakaiproject.tool.assessment.ui.listener.author.TemplateListener" />
    </h:commandLink>
    <h:outputText value="#{genMsg.separator} " />
    <h:commandLink title="#{genMsg.t_questionPool}" action="poolList" immediate="true">
      <h:outputText value="#{genMsg.questionPool}" />
    </h:commandLink>
</p>
<br/>
<!-- breadcrumb-->
<div>
    <h:commandLink title="#{msg.t_assessment}" rendered="#{itemauthor.target == 'assessment'}" action="author" immediate="true">
      <h:outputText value="#{msg.global_nav_assessmt}" />
    </h:commandLink>
    <h:outputText rendered="#{itemauthor.target == 'assessment'}" value=" #{msg.greater} " />
    <h:commandLink title="#{msg.t_question}" action="editAssessment" immediate="true" rendered="#{itemauthor.target == 'assessment'}">
      <h:outputText value="#{msg.qs}#{msg.column} #{assessmentBean.title}" />
    </h:commandLink>
    <h:outputText value=" #{msg.greater} " rendered="#{itemauthor.target == 'assessment'}" />
    <h:outputText value="#{msg.q} #{itemauthor.itemNo}" rendered="#{itemauthor.target == 'assessment'}"/>

</div>
<div>
<h:outputText rendered="#{itemauthor.target == 'questionpool'}" value="#{msg.global_nav_pools}> "/>

<samigo:dataLine rendered="#{itemauthor.target == 'questionpool'}" value="#{questionpool.currentPool.parentPoolsArray}" var="parent"
   separator=" > " first="0" rows="100" >
  <h:column>
    <h:commandLink action="#{questionpool.editPool}"  immediate="true">
      <h:outputText value="#{parent.displayName}" />
      <f:param name="qpid" value="#{parent.questionPoolId}"/>
    </h:commandLink>
  </h:column>
</samigo:dataLine>
<h:outputText rendered="#{questionpool.currentPool.showParentPools && itemauthor.target == 'questionpool'}" value=" #{msg.greater} " />
<h:commandLink rendered="#{itemauthor.target == 'questionpool'}" action="#{questionpool.editPool}"  immediate="true">
  <h:outputText value="#{questionpool.currentPool.displayName}"/>
  <f:param name="qpid" value="#{questionpool.currentPool.id}"/>
</h:commandLink>
</div>

<h3>
   <h:outputText value="#{msg.modify_q}#{msg.column} "/>
   <h:outputText value="#{assessmentBean.title}" rendered="#{itemauthor.target == 'assessment'}"/>
</h3>
<!-- CHANGE TYPE -->
<div class="tier1">
<div class=" shorttext"><h:outputLabel value="#{msg.change_q_type}"/>
<%-- todo:
listener set selectFromQuestionPool, eliminating the rendered attribute
--%>

<%-- from question pool context, do not show question pool as option --%>
<h:selectOneMenu accesskey="#{msg.a_options}" rendered="#{(itemauthor.target == 'assessment' && questionpool.importToAuthoring == 'true') || itemauthor.target == 'questionpool'}" onchange="changeTypeLink(this);"
  value="#{itemauthor.currentItem.itemType}" required="true" id="changeQType1">
  <f:valueChangeListener
           type="org.sakaiproject.tool.assessment.ui.listener.author.StartCreateItemListener" />

  <f:selectItems value="#{itemConfig.itemTypeSelectList}" />
</h:selectOneMenu>

<%-- not from qpool , show the last option: copy from question pool --%>
<h:selectOneMenu onchange="changeTypeLink(this);" rendered="#{itemauthor.target == 'assessment' && questionpool.importToAuthoring == 'false'}"
  value="#{itemauthor.currentItem.itemType}" required="true" id="changeQType2">
  <f:valueChangeListener
           type="org.sakaiproject.tool.assessment.ui.listener.author.StartCreateItemListener" />

  <f:selectItems value="#{itemConfig.itemTypeSelectList}" />
  <f:selectItem itemLabel="#{msg.import_from_q}" itemValue="10"/>
</h:selectOneMenu>

<h:commandLink id="hiddenlink" action="#{itemauthor.doit}" value="">
</h:commandLink>

<h:message rendered="#{questionpool.importToAuthoring == 'true' && itemauthor.target == 'assessment'}" for="changeQType1" styleClass="validate"/>
<h:message rendered="#{questionpool.importToAuthoring == 'false' && itemauthor.target == 'assessment'}" for="changeQType2" styleClass="validate"/>
</div>
<!-- SUBHEADING -->
<p class="navModeAction">
  <span class="leftNav">
   <b>
     <h:outputText value="#{msg.q}"/>
     <h:outputText rendered="#{itemauthor.target == 'assessment'}" value="#{itemauthor.itemNo}"/>
     <h:outputText value=" #{msg.dash} "/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType == 1}" value="#{msg.multiple_choice_type}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 2}" value="#{msg.multiple_choice_type}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 3}" value="#{msg.multiple_choice_surv}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 4}" value="#{msg.true_false}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 5}" value="#{msg.short_answer_essay}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 8}" value="#{msg.fill_in_the_blank}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 11}" value="#{msg.fill_in_numeric}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 9}" value="#{msg.matching}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 7}" value="#{msg.audio_recording}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 6}" value="#{msg.file_upload}"/>
     <h:outputText rendered="#{itemauthor.currentItem.itemType== 10}" value="#{msg.import_from_q}"/>
   </b>
 </span>
 <span class="rightNav">

 <%--
  temporily comment put Preview link for a specific question in Author. It will not be the feature in Sam 1.5.
  <h:commandLink id="preview" immediate="true" action="preview">
          <h:outputText value="#{msg.preview}" />
        <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.author.ItemModifyListener" />
  </h:commandLink>


  <h:outputText rendered="#{itemauthor.currentItem.itemId != null}" value=" #{msg.separator} " />
--%>
  <h:commandLink title="#{msg.t_removeQ}" rendered="#{itemauthor.currentItem.itemId != null}" styleClass="navList" immediate="true" id="deleteitem" action="#{itemauthor.confirmDeleteItem}">
                <h:outputText value="#{msg.button_remove}" />
                <f:param name="itemid" value="#{itemauthor.currentItem.itemId}"/>
              </h:commandLink>


<%-- removed MyQuestion link per new mockup
  <h:outputText rendered="#{itemauthor.target == 'assessment' && itemauthor.currentItem.itemId != null}" value=" | " />
  <h:commandLink immediate="true" rendered="#{itemauthor.target == 'assessment'}" action="editAssessment">
    <h:outputText value="#{msg.my_qs}" />
  </h:commandLink>
--%>
 </span>
 <br />
   <h:messages styleClass="validation"/>

 <br />

</p>
</div>
 <br />
</h:form>
