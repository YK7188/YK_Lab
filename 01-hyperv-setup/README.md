# Lab 01 – Hyper-V Network Setup

## Objective

Build a small virtualized network environment using Hyper-V.

---

## Environment

Host Machine

Windows PC
<br><br>
Virtualization Platform

Hyper-V
<br><br>
Server Machines

SRV1 – Domain Controller, DNS Server

SRV2 – RRAS Router / NAT Gateway, DHCP Server


[HV_topology.drawio](https://github.com/user-attachments/files/25797636/HV_topology.drawio)
<mxfile host="app.diagrams.net" agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0" version="29.6.1">
  <diagram name="Page-1" id="mJn4r8e-_Fbavof-Cazw">
    <mxGraphModel dx="1042" dy="563" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <mxCell id="guXkcimTEpV9OYgR5BCe-1" parent="1" style="ellipse;shape=cloud;whiteSpace=wrap;html=1;" value="Internet" vertex="1">
          <mxGeometry height="80" width="120" x="60" y="200" as="geometry" />
        </mxCell>
        <mxCell id="guXkcimTEpV9OYgR5BCe-2" parent="1" style="whiteSpace=wrap;html=1;aspect=fixed;" value="Host PC" vertex="1">
          <mxGeometry height="80" width="80" x="240" y="200" as="geometry" />
        </mxCell>
        <mxCell id="guXkcimTEpV9OYgR5BCe-3" edge="1" parent="1" source="guXkcimTEpV9OYgR5BCe-1" style="endArrow=none;html=1;rounded=0;exitX=0.875;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" target="guXkcimTEpV9OYgR5BCe-2" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="400" y="320" as="sourcePoint" />
            <mxPoint x="450" y="270" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="guXkcimTEpV9OYgR5BCe-4" parent="1" style="shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;" value="SRV2" vertex="1">
          <mxGeometry height="80" width="60" x="420" y="200" as="geometry" />
        </mxCell>
        <mxCell id="guXkcimTEpV9OYgR5BCe-5" edge="1" parent="1" source="guXkcimTEpV9OYgR5BCe-2" style="endArrow=none;html=1;rounded=0;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;" target="guXkcimTEpV9OYgR5BCe-4" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="400" y="320" as="sourcePoint" />
            <mxPoint x="410" y="240" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="guXkcimTEpV9OYgR5BCe-6" parent="1" style="shape=cylinder3;whiteSpace=wrap;html=1;boundedLbl=1;backgroundOutline=1;size=15;" value="SRV1" vertex="1">
          <mxGeometry height="80" width="60" x="580" y="200" as="geometry" />
        </mxCell>
        <mxCell id="guXkcimTEpV9OYgR5BCe-7" edge="1" parent="1" source="guXkcimTEpV9OYgR5BCe-4" style="endArrow=none;html=1;rounded=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;" target="guXkcimTEpV9OYgR5BCe-6" value="">
          <mxGeometry height="50" relative="1" width="50" as="geometry">
            <mxPoint x="400" y="320" as="sourcePoint" />
            <mxPoint x="450" y="270" as="targetPoint" />
          </mxGeometry>
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
