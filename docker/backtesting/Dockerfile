FROM regime-base:latest AS base

USER root
RUN pip install --no-cache-dir \
    regime-backtesting@git+https://github.com/RegimeDetectionApp/regime-backtesting.git@main
USER appuser

COPY --chown=appuser:appuser services/backtesting/ /app/services/backtesting/
EXPOSE 6004
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD python -c "import httpx; httpx.get('http://localhost:6004/health').raise_for_status()"
CMD ["uvicorn", "services.backtesting.app:app", "--host", "0.0.0.0", "--port", "6004"]
