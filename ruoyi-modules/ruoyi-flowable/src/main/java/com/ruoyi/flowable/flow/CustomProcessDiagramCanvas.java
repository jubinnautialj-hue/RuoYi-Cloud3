package com.ruoyi.flowable.flow;

import org.flowable.bpmn.model.AssociationDirection;
import org.flowable.bpmn.model.GraphicInfo;
import org.flowable.image.impl.DefaultProcessDiagramCanvas;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.font.FontRenderContext;
import java.awt.font.LineBreakMeasurer;
import java.awt.font.TextAttribute;
import java.awt.font.TextLayout;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Rectangle2D;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.text.AttributedCharacterIterator;
import java.text.AttributedString;

public class CustomProcessDiagramCanvas extends DefaultProcessDiagramCanvas {
    private static final Logger LOGGER = LoggerFactory.getLogger(CustomProcessDiagramCanvas.class);

    protected static Color HIGHLIGHT_SequenceFlow_COLOR = Color.GREEN;
    protected static Color CONNECTION_COLOR = Color.BLACK;
    protected static Color LABEL_COLOR = new Color(0, 0, 0);
    protected static Color HIGHLIGHT_COLOR = Color.GREEN;
    protected static Color HIGHLIGHT_COLOR1 = Color.RED;

    protected BufferedImage USERTASK_IMAGE;
    protected BufferedImage SCRIPTTASK_IMAGE;
    protected BufferedImage SERVICETASK_IMAGE;
    protected BufferedImage RECEIVETASK_IMAGE;
    protected BufferedImage SENDTASK_IMAGE;
    protected BufferedImage MANUALTASK_IMAGE;
    protected BufferedImage BUSINESS_RULE_TASK_IMAGE;
    protected BufferedImage DMN_TASK_IMAGE;
    protected BufferedImage HTTP_TASK_IMAGE;
    protected BufferedImage TIMER_IMAGE;
    protected BufferedImage COMPENSATE_THROW_IMAGE;
    protected BufferedImage COMPENSATE_CATCH_IMAGE;
    protected BufferedImage ERROR_THROW_IMAGE;
    protected BufferedImage ERROR_CATCH_IMAGE;
    protected BufferedImage MESSAGE_THROW_IMAGE;
    protected BufferedImage MESSAGE_CATCH_IMAGE;
    protected BufferedImage SIGNAL_THROW_IMAGE;
    protected BufferedImage SIGNAL_CATCH_IMAGE;

    public CustomProcessDiagramCanvas(int width, int height, int minX, int minY, String imageType, String activityFontName, String labelFontName, String annotationFontName, ClassLoader customClassLoader) {
        super(width, height, minX, minY, imageType, activityFontName, labelFontName, annotationFontName, customClassLoader);
        this.initialize(imageType);
    }

    @Override
    public void drawConnection(int[] xPoints, int[] yPoints, boolean conditional, boolean isDefault, String connectionType, AssociationDirection associationDirection, boolean highLighted, double scaleFactor) {
        Paint originalPaint = this.g.getPaint();
        Stroke originalStroke = this.g.getStroke();
        this.g.setPaint(CONNECTION_COLOR);
        if (connectionType.equals("association")) {
            this.g.setStroke(ASSOCIATION_STROKE);
        } else if (highLighted) {
            this.g.setPaint(HIGHLIGHT_SequenceFlow_COLOR);
            this.g.setStroke(HIGHLIGHT_FLOW_STROKE);
        }

        for (int i = 1; i < xPoints.length; ++i) {
            int sourceX = xPoints[i - 1];
            int sourceY = yPoints[i - 1];
            int targetX = xPoints[i];
            int targetY = yPoints[i];
            java.awt.geom.Line2D.Double line = new java.awt.geom.Line2D.Double((double) sourceX, (double) sourceY, (double) targetX, (double) targetY);
            this.g.draw(line);
        }

        java.awt.geom.Line2D.Double line;
        if (isDefault) {
            line = new java.awt.geom.Line2D.Double((double) xPoints[0], (double) yPoints[0], (double) xPoints[1], (double) yPoints[1]);
            this.drawDefaultSequenceFlowIndicator(line, scaleFactor);
        }

        if (conditional) {
            line = new java.awt.geom.Line2D.Double((double) xPoints[0], (double) yPoints[0], (double) xPoints[1], (double) yPoints[1]);
            this.drawConditionalSequenceFlowIndicator(line, scaleFactor);
        }

        if (associationDirection.equals(AssociationDirection.ONE) || associationDirection.equals(AssociationDirection.BOTH)) {
            line = new java.awt.geom.Line2D.Double((double) xPoints[xPoints.length - 2], (double) yPoints[xPoints.length - 2], (double) xPoints[xPoints.length - 1], (double) yPoints[xPoints.length - 1]);
            this.drawArrowHead(line, scaleFactor);
        }

        if (associationDirection.equals(AssociationDirection.BOTH)) {
            line = new java.awt.geom.Line2D.Double((double) xPoints[1], (double) yPoints[1], (double) xPoints[0], (double) yPoints[0]);
            this.drawArrowHead(line, scaleFactor);
        }

        this.g.setPaint(originalPaint);
        this.g.setStroke(originalStroke);
    }

    @Override
    public void initialize(String imageType) {
        if ("png".equalsIgnoreCase(imageType)) {
            this.processDiagram = new BufferedImage(this.canvasWidth, this.canvasHeight, 2);
        } else {
            this.processDiagram = new BufferedImage(this.canvasWidth, this.canvasHeight, 1);
        }

        this.g = this.processDiagram.createGraphics();
        if (!"png".equalsIgnoreCase(imageType)) {
            this.g.setBackground(new Color(255, 255, 255, 0));
            this.g.clearRect(0, 0, this.canvasWidth, this.canvasHeight);
        }

        this.g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        this.g.setPaint(Color.black);
        Font font = new Font(this.activityFontName, 10, 14);
        this.g.setFont(font);
        this.fontMetrics = this.g.getFontMetrics();
        LABEL_FONT = new Font(this.labelFontName, 10, 15);
        ANNOTATION_FONT = new Font(this.annotationFontName, 0, 11);

        ClassLoader classLoader = this.customClassLoader != null ? this.customClassLoader : getClass().getClassLoader();
        
        USERTASK_IMAGE = loadImage(classLoader, "org/flowable/icons/userTask.png");
        SCRIPTTASK_IMAGE = loadImage(classLoader, "org/flowable/icons/scriptTask.png");
        SERVICETASK_IMAGE = loadImage(classLoader, "org/flowable/icons/serviceTask.png");
        RECEIVETASK_IMAGE = loadImage(classLoader, "org/flowable/icons/receiveTask.png");
        SENDTASK_IMAGE = loadImage(classLoader, "org/flowable/icons/sendTask.png");
        MANUALTASK_IMAGE = loadImage(classLoader, "org/flowable/icons/manualTask.png");
        BUSINESS_RULE_TASK_IMAGE = loadImage(classLoader, "org/flowable/icons/businessRuleTask.png");
        DMN_TASK_IMAGE = loadImage(classLoader, "org/flowable/icons/dmnTask.png");
        HTTP_TASK_IMAGE = loadImage(classLoader, "org/flowable/icons/httpTask.png");
        TIMER_IMAGE = loadImage(classLoader, "org/flowable/icons/timer.png");
        COMPENSATE_THROW_IMAGE = loadImage(classLoader, "org/flowable/icons/compensate-throw.png");
        COMPENSATE_CATCH_IMAGE = loadImage(classLoader, "org/flowable/icons/compensate.png");
        ERROR_THROW_IMAGE = loadImage(classLoader, "org/flowable/icons/error-throw.png");
        ERROR_CATCH_IMAGE = loadImage(classLoader, "org/flowable/icons/error.png");
        MESSAGE_THROW_IMAGE = loadImage(classLoader, "org/flowable/icons/message-throw.png");
        MESSAGE_CATCH_IMAGE = loadImage(classLoader, "org/flowable/icons/message.png");
        SIGNAL_THROW_IMAGE = loadImage(classLoader, "org/flowable/icons/signal-throw.png");
        SIGNAL_CATCH_IMAGE = loadImage(classLoader, "org/flowable/icons/signal.png");
    }

    private BufferedImage loadImage(ClassLoader classLoader, String path) {
        try (InputStream is = classLoader.getResourceAsStream(path)) {
            if (is != null) {
                return ImageIO.read(is);
            }
        } catch (IOException e) {
            LOGGER.warn("Could not load image for process diagram creation: {}", path);
        }
        return null;
    }

    @Override
    public void drawLabel(String text, GraphicInfo graphicInfo, boolean centered) {
        float interline = 1.0f;

        if (text != null && text.length() > 0) {
            Paint originalPaint = g.getPaint();
            Font originalFont = g.getFont();

            g.setPaint(LABEL_COLOR);
            g.setFont(LABEL_FONT);

            int wrapWidth = 100;
            int textY = (int) graphicInfo.getY();

            AttributedString as = new AttributedString(text);
            as.addAttribute(TextAttribute.FOREGROUND, g.getPaint());
            as.addAttribute(TextAttribute.FONT, g.getFont());
            AttributedCharacterIterator aci = as.getIterator();
            FontRenderContext frc = new FontRenderContext(null, true, false);
            LineBreakMeasurer lbm = new LineBreakMeasurer(aci, frc);

            while (lbm.getPosition() < text.length()) {
                TextLayout tl = lbm.nextLayout(wrapWidth);
                textY += tl.getAscent();

                Rectangle2D bb = tl.getBounds();
                double tX = graphicInfo.getX();

                if (centered) {
                    tX += (int) (graphicInfo.getWidth() / 2 - bb.getWidth() / 2);
                }
                tl.draw(g, (float) tX, textY);
                textY += tl.getDescent() + tl.getLeading() + (interline - 1.0f) * tl.getAscent();
            }

            g.setFont(originalFont);
            g.setPaint(originalPaint);
        }
    }

    @Override
    public void drawHighLight(int x, int y, int width, int height) {
        Paint originalPaint = g.getPaint();
        Stroke originalStroke = g.getStroke();

        g.setPaint(HIGHLIGHT_COLOR);
        g.setStroke(THICK_TASK_BORDER_STROKE);

        RoundRectangle2D rect = new RoundRectangle2D.Double(x, y, width, height, 20, 20);
        g.draw(rect);

        g.setPaint(originalPaint);
        g.setStroke(originalStroke);
    }

    public void drawHighLightNow(int x, int y, int width, int height) {
        Paint originalPaint = g.getPaint();
        Stroke originalStroke = g.getStroke();

        g.setPaint(HIGHLIGHT_COLOR1);
        g.setStroke(THICK_TASK_BORDER_STROKE);

        RoundRectangle2D rect = new RoundRectangle2D.Double(x, y, width, height, 20, 20);
        g.draw(rect);

        g.setPaint(originalPaint);
        g.setStroke(originalStroke);
    }

    public void drawHighLightEnd(int x, int y, int width, int height) {
        Paint originalPaint = g.getPaint();
        Stroke originalStroke = g.getStroke();

        g.setPaint(HIGHLIGHT_COLOR);
        g.setStroke(THICK_TASK_BORDER_STROKE);

        RoundRectangle2D rect = new RoundRectangle2D.Double(x, y, width, height, 20, 20);
        g.draw(rect);

        g.setPaint(originalPaint);
        g.setStroke(originalStroke);
    }

    @Override
    protected void drawTask(String name, GraphicInfo graphicInfo, boolean thickBorder, double scaleFactor) {

        Paint originalPaint = g.getPaint();
        int x = (int) graphicInfo.getX();
        int y = (int) graphicInfo.getY();
        int width = (int) graphicInfo.getWidth();
        int height = (int) graphicInfo.getHeight();

        g.setPaint(TASK_BOX_COLOR);

        int arcR = 6;
        if (thickBorder) {
            arcR = 3;
        }

        RoundRectangle2D rect = new RoundRectangle2D.Double(x, y, width, height, arcR, arcR);
        g.fill(rect);
        g.setPaint(TASK_BORDER_COLOR);

        if (thickBorder) {
            Stroke originalStroke = g.getStroke();
            g.setStroke(THICK_TASK_BORDER_STROKE);
            g.draw(rect);
            g.setStroke(originalStroke);
        } else {
            g.draw(rect);
        }

        g.setPaint(originalPaint);
        if (scaleFactor == 1.0 && name != null && name.length() > 0) {
            int boxWidth = width - (2 * TEXT_PADDING);
            int boxHeight = height - 16 - ICON_PADDING - ICON_PADDING - MARKER_WIDTH - 2 - 2;
            int boxX = x + width / 2 - boxWidth / 2;
            int boxY = y + height / 2 - boxHeight / 2 + ICON_PADDING + ICON_PADDING - 2 - 2;

            drawMultilineCentredText(name, boxX, boxY, boxWidth, boxHeight);
        }
    }

    protected static Color EVENT_COLOR = new Color(255, 255, 255);

    @Override
    public void drawStartEvent(GraphicInfo graphicInfo, BufferedImage image, double scaleFactor) {
        Paint originalPaint = g.getPaint();
        g.setPaint(EVENT_COLOR);
        Ellipse2D circle = new Ellipse2D.Double(graphicInfo.getX(), graphicInfo.getY(),
                graphicInfo.getWidth(), graphicInfo.getHeight());
        g.fill(circle);
        g.setPaint(EVENT_BORDER_COLOR);
        g.draw(circle);
        g.setPaint(originalPaint);
        if (image != null) {
            int imageX = (int) Math.round(graphicInfo.getX() + (graphicInfo.getWidth() / 2) - (image.getWidth() / (2 * scaleFactor)));
            int imageY = (int) Math.round(graphicInfo.getY() + (graphicInfo.getHeight() / 2) - (image.getHeight() / (2 * scaleFactor)));
            g.drawImage(image, imageX, imageY,
                    (int) (image.getWidth() / scaleFactor), (int) (image.getHeight() / scaleFactor), null);
        }

    }

    @Override
    public void drawNoneEndEvent(GraphicInfo graphicInfo, double scaleFactor) {
        Paint originalPaint = g.getPaint();
        Stroke originalStroke = g.getStroke();
        g.setPaint(EVENT_COLOR);
        Ellipse2D circle = new Ellipse2D.Double(graphicInfo.getX(), graphicInfo.getY(),
                graphicInfo.getWidth(), graphicInfo.getHeight());
        g.fill(circle);
        g.setPaint(EVENT_BORDER_COLOR);
        if (scaleFactor == 1.0) {
            g.setStroke(END_EVENT_STROKE);
        } else {
            g.setStroke(new BasicStroke(2.0f));
        }
        g.draw(circle);
        g.setStroke(originalStroke);
        g.setPaint(originalPaint);
    }
}
