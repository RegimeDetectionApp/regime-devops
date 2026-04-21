FROM regime-base:latest AS base

USER root
RUN pip install --no-cache-dir hmmlearn>=0.3 \
    regime-detection-core@git+https://github.com/RegimeDetectionApp/regime-detection-core.git@main \
    regime-feature-engine@git+https://github.com/RegimeDetectionApp/regime-feature-engine.git@main
USER appuser

COPY --chown=appuser:appuser services/detection_core/ /app/services/detection_core/
EXPOSE 7003
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD python -c "import httpx; httpx.get('http://localhost:7003/health').raise_for_status()"
CMD ["uvicorn", "services.detection_core.app:app", "--host", "0.0.0.0", "--port", "7003"]
